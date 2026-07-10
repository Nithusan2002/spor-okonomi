import SwiftUI
import SwiftData
import UIKit

struct ShareURL: Identifiable {
    let id = UUID()
    let url: URL
    init(_ url: URL) { self.url = url }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    var onComplete: (() -> Void)?

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        controller.completionWithItemsHandler = { _, _, _, _ in
            DispatchQueue.main.async {
                onComplete?()
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct SecureExportSheet: View {
    @Binding var password: String
    @Binding var confirmation: String
    let onCancel: () -> Void
    let onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section {
                SecureField("Passord", text: $password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Bekreft passord", text: $confirmation)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } footer: {
                Text("Eksportfilen lagres kryptert. Du trenger dette passordet for å importere filen senere.")
            }
        }
        .navigationTitle("Kryptert eksport")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Avbryt") {
                    onCancel()
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Eksporter") {
                    onConfirm()
                    dismiss()
                }
            }
        }
    }
}

struct SecureImportSheet: View {
    @Binding var password: String
    let onCancel: () -> Void
    let onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section {
                SecureField("Passord (valgfritt)", text: $password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } footer: {
                Text("Skriv inn passord hvis filen er kryptert. La feltet stå tomt for eldre ukrypterte eksportfiler.")
            }
        }
        .navigationTitle("Importer data")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Avbryt") {
                    onCancel()
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Importer") {
                    onConfirm()
                    dismiss()
                }
            }
        }
    }
}

struct ReminderSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var enabled: Bool
    @State private var selectedDay: Int

    let onSave: (Bool, Int) -> Void

    init(
        enabled: Bool,
        day: Int,
        onSave: @escaping (Bool, Int) -> Void
    ) {
        self._enabled = State(initialValue: enabled)
        self._selectedDay = State(initialValue: max(1, min(28, day)))
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                Toggle("Månedlig innsjekk", isOn: $enabled)
                    .appBodyStyle()

                if enabled {
                    Stepper("Dag i måneden: \(selectedDay)", value: $selectedDay, in: 1...28)
                    Text("Påminnelsen sendes alltid kl 12:00.")
                        .appSecondaryStyle()

                    Text("Når du slår dette på, kan iOS be om tillatelse til varsler. Det brukes bare til månedlig innsjekk.")
                        .appSecondaryStyle()
                } else {
                    Text("Påminnelser er av. Du kan fortsatt oppdatere manuelt når som helst.")
                        .appSecondaryStyle()
                }

                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("Månedlig innsjekk")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Lagre") {
                        onSave(enabled, selectedDay)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct BucketTypesSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \InvestmentBucket.sortOrder) private var buckets: [InvestmentBucket]
    @StateObject private var viewModel = InvestmentsViewModel()
    @State private var editMode: EditMode = .inactive

    private var activeBuckets: [InvestmentBucket] {
        buckets.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    private var hiddenBuckets: [InvestmentBucket] {
        buckets.filter { !$0.isActive }.sorted { $0.sortOrder < $1.sortOrder }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Aktive typer") {
                    if activeBuckets.isEmpty {
                        Text("Ingen aktive beholdningstyper.")
                            .appSecondaryStyle()
                    } else {
                        ForEach(activeBuckets) { bucket in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(AppTheme.portfolioColor(for: bucket))
                                    .frame(width: 10, height: 10)

                                Text(bucket.name)
                                    .appBodyStyle()

                                Spacer()

                                if editMode == .inactive && activeBuckets.count > 1 {
                                    Button("Skjul") {
                                        viewModel.hideBucket(bucket, context: modelContext)
                                    }
                                    .font(.footnote.weight(.semibold))
                                    .buttonStyle(.bordered)
                                    .tint(AppTheme.textSecondary)
                                }
                            }
                        }
                        .onMove { source, destination in
                            viewModel.moveActiveBuckets(
                                from: source,
                                to: destination,
                                allBuckets: buckets,
                                context: modelContext
                            )
                        }
                    }
                }

                Section("Skjulte typer") {
                    if hiddenBuckets.isEmpty {
                        Text("Ingen skjulte beholdningstyper.")
                            .appSecondaryStyle()
                    } else {
                        ForEach(hiddenBuckets) { bucket in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(AppTheme.portfolioColor(for: bucket).opacity(0.4))
                                    .frame(width: 10, height: 10)

                                Text(bucket.name)
                                    .appSecondaryStyle()

                                Spacer()

                                Button("Vis") {
                                    viewModel.restoreBucket(bucket, context: modelContext, existingBuckets: buckets)
                                }
                                .font(.footnote.weight(.semibold))
                                .buttonStyle(.bordered)
                                .tint(AppTheme.primary)
                            }
                        }
                    }
                }

                Section("Ny beholdningstype") {
                    TextField("Navn på type", text: $viewModel.newBucketName)
                        .textFieldStyle(.appInput)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(AppTheme.customBucketPalette, id: \.self) { hex in
                                let selected = viewModel.selectedBucketColorHex == hex
                                Button {
                                    viewModel.selectedBucketColorHex = hex
                                } label: {
                                    Circle()
                                        .fill(Color(hex: hex))
                                        .frame(width: 26, height: 26)
                                        .overlay {
                                            Circle()
                                                .stroke(selected ? AppTheme.textPrimary : AppTheme.divider, lineWidth: selected ? 2 : 1)
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Button("Legg til type") {
                        _ = viewModel.addBucket(context: modelContext, existingBuckets: buckets)
                    }
                    .appProminentCTAStyle()
                    .disabled(viewModel.newBucketName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                    if let addError = viewModel.addBucketError {
                        Text(addError)
                            .font(.footnote)
                            .foregroundStyle(AppTheme.negative)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle("Beholdningstyper")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Lukk") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if activeBuckets.count > 1 {
                        EditButton()
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .alert(
                "Kunne ikke lagre",
                isPresented: Binding(
                    get: { viewModel.persistenceErrorMessage != nil },
                    set: { if !$0 { viewModel.clearPersistenceError() } }
                )
            ) {
                Button("OK", role: .cancel) {
                    viewModel.clearPersistenceError()
                }
            } message: {
                Text(viewModel.persistenceErrorMessage ?? "")
            }
        }
    }
}
