import SwiftUI
import UniformTypeIdentifiers

struct AccountSettingsHomeView: View {
    let authEmail: String?
    let isReadOnlyMode: Bool
    let onCreateAccount: () -> Void
    let onSignInWithEmail: () -> Void
    let onSignInWithGoogle: () -> Void
    let onSignOut: () -> Void

    var body: some View {
        Form {
            SettingsAccountSection(
                authEmail: authEmail,
                isReadOnlyMode: isReadOnlyMode,
                onCreateAccount: onCreateAccount,
                onSignInWithEmail: onSignInWithEmail,
                onSignInWithGoogle: onSignInWithGoogle,
                onSignOut: onSignOut
            )
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.background)
        .navigationTitle("Konto og synk")
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 86)
                .allowsHitTesting(false)
        }
    }
}

struct AppSettingsHomeView: View {
    let pref: UserPreference
    let isReadOnlyMode: Bool
    @Binding var appearanceModeBinding: AppAppearancePreference
    @Binding var settingsErrorMessage: String?
    let onPersistSettings: (Bool) -> Void
    let onApplyReminderSettings: (Bool, Int) -> Void

    @State private var showReminderSheet = false

    var body: some View {
        Form {
            Section {
                NavigationLink {
                    AppearanceSettingsView(selection: $appearanceModeBinding)
                } label: {
                    settingsRow(title: "Visning", value: appearanceModeBinding.title, showsChevron: false)
                }
                .buttonStyle(.plain)

                Toggle(isOn: reminderEnabledBinding) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Månedlig innsjekk")
                            .appBodyStyle()
                        Text(reminderToggleSubtitle)
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                .disabled(isReadOnlyMode)

                if pref.checkInReminderEnabled {
                    Button {
                        showReminderSheet = true
                    } label: {
                        settingsRow(title: "Påminnelsesdag", value: "\(pref.checkInReminderDay). i måneden", showsChevron: true)
                    }
                    .buttonStyle(.plain)
                    .disabled(isReadOnlyMode)
                }

                Toggle(isOn: faceIDBinding) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Face ID-lås")
                            .appBodyStyle()
                        Text("Ber om Face ID eller kode når appen åpnes igjen på denne enheten.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                .disabled(isReadOnlyMode)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.background)
        .navigationTitle("App")
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 86)
                .allowsHitTesting(false)
        }
        .sheet(isPresented: $showReminderSheet) {
            ReminderSettingsSheet(
                enabled: pref.checkInReminderEnabled,
                day: pref.checkInReminderDay
            ) { enabled, day in
                onApplyReminderSettings(enabled, day)
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    private var reminderEnabledBinding: Binding<Bool> {
        Binding(
            get: { pref.checkInReminderEnabled },
            set: { isEnabled in
                guard !isReadOnlyMode else {
                    settingsErrorMessage = PersistenceWriteError.readOnlyMode.localizedDescription
                    return
                }
                onApplyReminderSettings(isEnabled, pref.checkInReminderDay)
            }
        )
    }

    private var faceIDBinding: Binding<Bool> {
        Binding(
            get: { pref.faceIDLockEnabled },
            set: { newValue in
                guard !isReadOnlyMode else {
                    settingsErrorMessage = PersistenceWriteError.readOnlyMode.localizedDescription
                    return
                }
                pref.faceIDLockEnabled = newValue
                onPersistSettings(false)
            }
        )
    }

    private var reminderToggleSubtitle: String {
        pref.checkInReminderEnabled ? "Varsel på den \(pref.checkInReminderDay). hver måned" : "Av"
    }

    private func settingsRow(title: String, value: String, showsChevron: Bool) -> some View {
        HStack {
            Text(title)
                .appBodyStyle()
            Spacer()
            if !value.isEmpty {
                Text(value)
                    .appSecondaryStyle()
            }
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

struct EconomySettingsHomeView: View {
    let pref: UserPreference
    let isReadOnlyMode: Bool
    let investmentBuckets: [InvestmentBucket]

    @State private var showGoalSheet = false
    @State private var showBucketTypesSheet = false

    var body: some View {
        Form {
            Section {
                NavigationLink {
                    FixedItemsView()
                } label: {
                    settingsRow(title: "Faste poster", value: "", showsChevron: false)
                }
                .buttonStyle(.plain)

                Button {
                    showBucketTypesSheet = true
                } label: {
                    settingsRow(title: "Beholdningstyper", value: bucketSummaryText, showsChevron: true)
                }
                .buttonStyle(.plain)

                Button {
                    showGoalSheet = true
                } label: {
                    settingsRow(title: "Mål", value: "", showsChevron: true)
                }
                .buttonStyle(.plain)

                NavigationLink {
                    CategoryManagementView()
                } label: {
                    settingsRow(title: "Kategorier", value: "", showsChevron: false)
                }
                .buttonStyle(.plain)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.background)
        .navigationTitle("Oppsett")
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 86)
                .allowsHitTesting(false)
        }
        .disabled(isReadOnlyMode)
        .sheet(isPresented: $showGoalSheet) {
            GoalEditorView(goal: nil)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showBucketTypesSheet) {
            BucketTypesSettingsSheet()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private var bucketSummaryText: String {
        let activeCount = investmentBuckets.filter(\.isActive).count
        return activeCount == 1 ? "1 aktiv" : "\(activeCount) aktive"
    }

    private func settingsRow(title: String, value: String, showsChevron: Bool) -> some View {
        HStack {
            Text(title)
                .appBodyStyle()
            Spacer()
            if !value.isEmpty {
                Text(value)
                    .appSecondaryStyle()
            }
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

struct DataPrivacySettingsHomeView: View {
    private enum DangerousAction: String, Identifiable {
        case wipeDemo
        case deleteAccount
        case deleteLocalData

        var id: String { rawValue }

        var initialTitle: String {
            switch self {
            case .wipeDemo:
                return "Tøm demo-data?"
            case .deleteAccount:
                return "Slett konto?"
            case .deleteLocalData:
                return "Slett lokale data?"
            }
        }

        var initialMessage: String {
            switch self {
            case .wipeDemo:
                return "Dette sletter alt lokalt på enheten."
            case .deleteAccount:
                return "Dette sletter kontoen din og rydder lokale data på denne enheten. iCloud-data fjernes når slettingen er synkronisert."
            case .deleteLocalData:
                return "Dette sletter budsjett, investeringer, mål og innstillinger lokalt på denne enheten. Dette sletter ikke kontoen din."
            }
        }

        var finalTitle: String {
            switch self {
            case .wipeDemo, .deleteLocalData:
                return "Er du helt sikker?"
            case .deleteAccount:
                return "Slette konto permanent?"
            }
        }

        var finalMessage: String {
            switch self {
            case .wipeDemo:
                return "Demo-dataene blir slettet permanent fra denne enheten."
            case .deleteAccount:
                return "Kontoen din blir slettet permanent. Denne handlingen kan ikke angres."
            case .deleteLocalData:
                return "Alle lokale data på denne enheten blir slettet. Denne handlingen kan ikke angres."
            }
        }

        var confirmTitle: String {
            switch self {
            case .wipeDemo:
                return "Ja, tøm demo-data"
            case .deleteAccount:
                return "Ja, slett konto"
            case .deleteLocalData:
                return "Ja, slett lokale data"
            }
        }
    }

    private enum DangerousConfirmation: Identifiable {
        case initial(DangerousAction)
        case final(DangerousAction)

        var id: String {
            switch self {
            case .initial(let action):
                return "initial-\(action.id)"
            case .final(let action):
                return "final-\(action.id)"
            }
        }
    }

    let isReadOnlyMode: Bool
    let storageLocationText: String
    let storeModeText: String
    let storeModeDetailText: String?
    let isAuthenticated: Bool
    let shouldShowDemoTools: Bool
    let onExport: () -> Void
    @Binding var importPickerIsPresented: Bool
    let onSelectImportMode: (DataImportMode) -> Void
    let onImportResult: (Result<[URL], Error>) -> Void
    let onConfirmDeleteAccount: () -> Void
    let onConfirmDeleteAll: () -> Void
    let onLoadDemo: () -> Void
    let onLoadMarketingDemo: () -> Void
    let onConfirmDemoWipe: () -> Void
    @Environment(\.openURL) private var openURL
    @State private var dangerousConfirmation: DangerousConfirmation?
    @State private var showDemoLoadConfirm = false
    @State private var showMarketingDemoLoadConfirm = false
    @State private var showImportModeDialog = false

    private let privacyPolicyURL = URL(string: "https://nithusan2002.github.io/spor-okonomi/personvern/")
    private let termsURL = URL(string: "https://nithusan2002.github.io/spor-okonomi/vilkar/")

    var body: some View {
        Form {
            Section {
                NavigationLink {
                    StorageDiagnosticsView(
                        storageLocationText: storageLocationText,
                        storeModeText: storeModeText,
                        storeModeDetailText: storeModeDetailText,
                        isReadOnlyMode: isReadOnlyMode
                    )
                } label: {
                    settingsRow(title: "Lagring", value: storageLocationText, showsChevron: false)
                }
                .buttonStyle(.plain)

                Button {
                    onExport()
                } label: {
                    settingsRow(title: "Eksporter data", value: "", showsChevron: true)
                }
                .buttonStyle(.plain)

                Button {
                    showImportModeDialog = true
                } label: {
                    settingsRow(title: "Importer data", value: "", showsChevron: true)
                }
                .buttonStyle(.plain)
                .disabled(isReadOnlyMode)

                Button {
                    guard let privacyPolicyURL else { return }
                    openURL(privacyPolicyURL)
                } label: {
                    settingsRow(title: "Personvern", value: "", showsChevron: true)
                }
                .buttonStyle(.plain)

                Button {
                    guard let termsURL else { return }
                    openURL(termsURL)
                } label: {
                    settingsRow(title: "Vilkår", value: "", showsChevron: true)
                }
                .buttonStyle(.plain)
            }

            Section {
                NavigationLink {
                    StorageDiagnosticsView(
                        storageLocationText: storageLocationText,
                        storeModeText: storeModeText,
                        storeModeDetailText: storeModeDetailText,
                        isReadOnlyMode: isReadOnlyMode
                    )
                } label: {
                    settingsRow(title: "Synk og diagnose", value: storeModeText, showsChevron: false)
                }
                .buttonStyle(.plain)

                if shouldShowDemoTools {
                    Button("Last inn marketing-demo") {
                        showMarketingDemoLoadConfirm = true
                    }
                    .buttonStyle(.plain)
                    .disabled(isReadOnlyMode)

                    Button("Last inn demo (3 år realistisk)") {
                        showDemoLoadConfirm = true
                    }
                    .buttonStyle(.plain)
                    .disabled(isReadOnlyMode)

                    Button(role: .destructive) {
                        dangerousConfirmation = .initial(.wipeDemo)
                    } label: {
                        destructiveSettingsRow(title: "Tøm demo-data")
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text("Avansert")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(AppTheme.textSecondary)
                    .textCase(nil)
                    .padding(.top, 6)
            }

            Section {
                if isAuthenticated {
                    Button(role: .destructive) {
                        dangerousConfirmation = .initial(.deleteAccount)
                    } label: {
                        destructiveSettingsRow(title: "Slett konto")
                    }
                    .buttonStyle(.plain)
                }

                Button(role: .destructive) {
                    dangerousConfirmation = .initial(.deleteLocalData)
                } label: {
                    destructiveSettingsRow(title: "Slett lokale data")
                }
                .buttonStyle(.plain)
            } header: {
                Text("Farlige handlinger")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(AppTheme.negative)
                    .textCase(nil)
                    .padding(.top, 6)
            } footer: {
                Text("Disse handlingene kan ikke angres.")
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.background)
        .navigationTitle("Data og personvern")
        .alert("Last inn demo-data?", isPresented: $showDemoLoadConfirm) {
            Button("Avbryt", role: .cancel) { }
            Button("Last inn demo", role: .destructive) {
                onLoadDemo()
            }
        } message: {
            Text("Dette erstatter lokale data på denne enheten med demo-data.")
        }
        .alert("Last inn marketing-demo?", isPresented: $showMarketingDemoLoadConfirm) {
            Button("Avbryt", role: .cancel) { }
            Button("Last inn marketing-demo", role: .destructive) {
                onLoadMarketingDemo()
            }
        } message: {
            Text("Dette erstatter lokale data på denne enheten med et kuratert demooppsett for screenshots og markedsflater.")
        }
        .alert("Importer data", isPresented: $showImportModeDialog) {
            Button("Slå sammen med eksisterende data") {
                onSelectImportMode(.merge)
            }
            Button("Erstatt all data", role: .destructive) {
                onSelectImportMode(.replace)
            }
            Button("Avbryt", role: .cancel) { }
        } message: {
            Text("Velg hvordan importen skal håndtere data som allerede finnes.")
        }
        .fileImporter(
            isPresented: $importPickerIsPresented,
            allowedContentTypes: [UTType.json, UTType.data],
            allowsMultipleSelection: false
        ) { result in
            onImportResult(result)
        }
        .alert(item: $dangerousConfirmation) { confirmation in
            switch confirmation {
            case .initial(let action):
                return Alert(
                    title: Text(action.initialTitle),
                    message: Text(action.initialMessage),
                    primaryButton: .destructive(Text(action.confirmTitle)) {
                        dangerousConfirmation = .final(action)
                    },
                    secondaryButton: .cancel(Text("Avbryt"))
                )
            case .final(let action):
                return Alert(
                    title: Text(action.finalTitle),
                    message: Text(action.finalMessage),
                    primaryButton: .destructive(Text(action.confirmTitle)) {
                        switch action {
                        case .wipeDemo:
                            onConfirmDemoWipe()
                        case .deleteAccount:
                            onConfirmDeleteAccount()
                        case .deleteLocalData:
                            onConfirmDeleteAll()
                        }
                    },
                    secondaryButton: .cancel(Text("Avbryt"))
                )
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 86)
                .allowsHitTesting(false)
        }
    }

    private func settingsRow(title: String, value: String, showsChevron: Bool) -> some View {
        HStack {
            Text(title)
                .appBodyStyle()
            Spacer()
            if !value.isEmpty {
                Text(value)
                    .appSecondaryStyle()
                    .truncationMode(.tail)
            }
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }

    private func destructiveSettingsRow(title: String) -> some View {
        HStack {
            Text(title)
                .font(.body.weight(.semibold))
                .foregroundStyle(AppTheme.negative)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}
