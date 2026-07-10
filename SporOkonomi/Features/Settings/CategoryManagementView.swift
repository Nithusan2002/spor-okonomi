import SwiftUI
import SwiftData

struct CategoryManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.sortOrder) private var categories: [Category]

    @State private var editorState: CategoryEditorState?
    @State private var saveErrorMessage: String?
    private var isReadOnlyMode: Bool { PersistenceGate.isReadOnlyMode }

    var body: some View {
        List {
            if categories.isEmpty {
                Text("Ingen kategorier ennå")
                    .appSecondaryStyle()
            } else {
                Section("Kategorier") {
                    ForEach(categories) { category in
                        Button {
                            editorState = .edit(category)
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(category.name)
                                        .appBodyStyle()
                                    Text(typeText(category.type))
                                        .appSecondaryStyle()
                                }
                                Spacer()
                                Toggle("", isOn: Binding(
                                    get: { category.isActive },
                                    set: { newValue in
                                        if isReadOnlyMode {
                                            saveErrorMessage = PersistenceWriteError.readOnlyMode.localizedDescription
                                            return
                                        }
                                        let previousValue = category.isActive
                                        category.isActive = newValue
                                        do {
                                            try modelContext.guardedSave(feature: "Categories", operation: "toggle_category")
                                        } catch {
                                            category.isActive = previousValue
                                            saveErrorMessage = (error as? LocalizedError)?.errorDescription ?? "Kunne ikke lagre kategori."
                                        }
                                    }
                                ))
                                .labelsHidden()
                            }
                            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Kategorier")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editorState = .new
                } label: {
                    Label("Legg til", systemImage: "plus")
                }
                .disabled(isReadOnlyMode)
            }
        }
        .sheet(item: $editorState) { state in
            CategoryEditorSheet(state: state) { input in
                save(input: input, state: state)
            }
        }
        .alert(
            "Kunne ikke lagre kategori",
            isPresented: Binding(
                get: { saveErrorMessage != nil },
                set: { if !$0 { saveErrorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {
                saveErrorMessage = nil
            }
        } message: {
            Text(saveErrorMessage ?? "")
        }
    }

    private func save(input: CategoryEditorInput, state: CategoryEditorState) {
        guard !isReadOnlyMode else {
            saveErrorMessage = PersistenceWriteError.readOnlyMode.localizedDescription
            return
        }
        let trimmedName = input.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        switch state {
        case .new:
            let sortOrder = (categories.map(\.sortOrder).max() ?? 0) + 1
            let category = Category(
                name: trimmedName,
                type: input.type,
                groupKey: input.groupKey,
                isActive: true,
                sortOrder: sortOrder
            )
            modelContext.insert(category)
        case .edit(let category):
            category.name = trimmedName
            category.type = input.type
            category.groupKey = input.groupKey
            category.isActive = input.isActive
        }

        do {
            try modelContext.guardedSave(feature: "Categories", operation: "save_category")
        } catch {
            saveErrorMessage = (error as? LocalizedError)?.errorDescription ?? "Kunne ikke lagre kategori."
        }
    }

    private func typeText(_ type: CategoryType) -> String {
        switch type {
        case .expense:
            return "Utgift"
        case .income:
            return "Inntekt"
        case .savings:
            return "Sparing"
        }
    }
}

private enum CategoryEditorState: Identifiable {
    case new
    case edit(Category)

    var id: String {
        switch self {
        case .new:
            return "new"
        case .edit(let category):
            return category.id
        }
    }
}

private struct CategoryEditorInput {
    var name: String
    var type: CategoryType
    var groupKey: String
    var isActive: Bool
}

private struct CategoryEditorSheet: View {
    @Environment(\.dismiss) private var dismiss

    let state: CategoryEditorState
    let onSave: (CategoryEditorInput) -> Void

    @State private var name: String = ""
    @State private var type: CategoryType = .expense
    @State private var groupKey: String = BudgetGroup.annet.rawValue
    @State private var groupWasManuallySet = false
    @State private var isActive: Bool = true

    private var title: String {
        switch state {
        case .new:
            return "Ny kategori"
        case .edit:
            return "Rediger kategori"
        }
    }

    private var sortedGroups: [BudgetGroup] {
        BudgetGroup.allCases.sorted { $0.sortOrder < $1.sortOrder }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Detaljer") {
                    TextField("Navn", text: $name)
                        .textInputAutocapitalization(.sentences)
                        .onChange(of: name) { _, newValue in
                            guard case .new = state, !groupWasManuallySet else { return }
                            groupKey = Category.defaultGroupKey(forName: newValue, type: type)
                        }

                    Picker("Type", selection: $type) {
                        Text("Utgift").tag(CategoryType.expense)
                        Text("Inntekt").tag(CategoryType.income)
                        Text("Sparing").tag(CategoryType.savings)
                    }
                    .onChange(of: type) { _, newValue in
                        guard case .new = state, !groupWasManuallySet else { return }
                        groupKey = Category.defaultGroupKey(forName: name, type: newValue)
                    }

                    if type != .income {
                        Picker("Gruppe", selection: Binding(
                            get: { groupKey },
                            set: { newValue in
                                groupKey = newValue
                                groupWasManuallySet = true
                            }
                        )) {
                            ForEach(sortedGroups) { group in
                                Text(group.title).tag(group.rawValue)
                            }
                        }
                    }

                    Toggle("Aktiv", isOn: $isActive)
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Lagre") {
                        onSave(CategoryEditorInput(name: name, type: type, groupKey: groupKey, isActive: isActive))
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                switch state {
                case .new:
                    groupKey = Category.defaultGroupKey(forName: name, type: type)
                case .edit(let category):
                    name = category.name
                    type = category.type
                    groupKey = category.groupKey
                    isActive = category.isActive
                    groupWasManuallySet = true
                }
            }
        }
    }
}
