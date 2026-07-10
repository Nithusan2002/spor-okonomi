import SwiftUI
import SwiftData

struct SettingsView: View {
    private let privacyPolicyURL = URL(string: "https://nithusan2002.github.io/spor-okonomi/personvern/")
    private let termsURL = URL(string: "https://nithusan2002.github.io/spor-okonomi/vilkar/")

    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var sessionStore: SessionStore
    @EnvironmentObject private var navigationState: AppNavigationState
    @Query private var preferences: [UserPreference]
    @Query(sort: \InvestmentBucket.sortOrder) private var investmentBuckets: [InvestmentBucket]
    @AppStorage("app_appearance_mode") private var appAppearanceModeRawValue = AppAppearancePreference.followSystem.rawValue
    @State private var viewModel = SettingsViewModel()

    @State private var showReminderSheet = false
    @State private var showGoalSheet = false
    @State private var showBucketTypesSheet = false
    @State private var shareItem: ShareURL?
    @State private var sharedExportURL: URL?
    @State private var showExportError = false
    @State private var showExportPasswordSheet = false
    @State private var exportMessage = ""
    @State private var exportPassword = ""
    @State private var exportPasswordConfirmation = ""
    @State private var showDeleteAllConfirm = false
    @State private var showDeleteAllError = false
    @State private var showDeleteAllSuccess = false
    @State private var showDeleteAccountConfirm = false
    @State private var showDeleteAccountSuccess = false
    @State private var showDemoLoadError = false
    @State private var showDemoLoadSuccess = false
    @State private var showDemoWipeConfirm = false
    @State private var showImportModeDialog = false
    @State private var showImportPicker = false
    @State private var showImportError = false
    @State private var showImportPasswordSheet = false
    @State private var showImportSuccess = false
    @State private var showAccountSettingsHome = false
    @State private var pendingImportMode: DataImportMode = .merge
    @State private var pendingImportURL: URL?
    @State private var importPassword = ""
    @State private var importMessage = ""
    @State private var settingsErrorMessage: String?
    @State private var ensuredPreference: UserPreference?
    @State private var demoLoadMessage = ""
    @State private var demoToastMessage: String?
    @State private var emailAuthMode: EmailAuthMode?

    private var pref: UserPreference {
        if let existing = preferences.first ?? ensuredPreference {
            return existing
        }
        assertionFailure("Preference should be available before settings form is rendered.")
        return UserPreference()
    }
    private var isReadOnlyMode: Bool { PersistenceGate.isReadOnlyMode }

    var body: some View {
        Group {
            if preferences.first == nil && ensuredPreference == nil {
                ProgressView("Laster inn innstillinger…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(AppTheme.background)
                    .onAppear {
                        ensurePreference()
                    }
            } else {
                configuredForm
            }
        }
    }

    private var baseForm: some View {
        Form {
            settingsHomeSection
            homeLanguageSection
        }
        .onAppear {
            ensurePreference()
        }
        .onChange(of: preferences.count) { _, _ in
            ensurePreference()
        }
        .task {
            await viewModel.refreshDemoToolVisibilityIfNeeded()
        }
    }

    private var configuredForm: some View {
        formWithAlerts
            .safeAreaInset(edge: .bottom) {
                Color.clear
                    .frame(height: 86)
                    .allowsHitTesting(false)
            }
            .safeAreaInset(edge: .bottom) {
                if let demoToastMessage {
                    Text(demoToastMessage)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(AppTheme.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(AppTheme.surfaceElevated, in: Capsule())
                        .overlay(Capsule().stroke(AppTheme.divider, lineWidth: 1))
                        .padding(.bottom, 6)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
    }

    private var formWithSheets: some View {
        baseForm
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle("Innstillinger")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showReminderSheet) {
            ReminderSettingsSheet(
                enabled: pref.checkInReminderEnabled,
                day: pref.checkInReminderDay
            ) { enabled, day in
                applyReminderSettings(enabled: enabled, day: day)
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
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
            .sheet(item: $shareItem, onDismiss: {
                cleanupSharedExportFile()
            }) { item in
            ShareSheet(activityItems: [item.url]) {
                cleanupSharedExportFile()
            }
            }
            .sheet(isPresented: $showExportPasswordSheet) {
            NavigationStack {
                SecureExportSheet(
                    password: $exportPassword,
                    confirmation: $exportPasswordConfirmation,
                    onCancel: {
                        resetExportPasswordState()
                        showExportPasswordSheet = false
                    },
                    onConfirm: {
                        performExport()
                    }
                )
            }
            }
            .sheet(isPresented: $showImportPasswordSheet, onDismiss: {
                resetImportPasswordState()
            }) {
            NavigationStack {
                SecureImportSheet(
                    password: $importPassword,
                    onCancel: {
                        pendingImportURL = nil
                        showImportPasswordSheet = false
                    },
                    onConfirm: {
                        performImport()
                    }
                )
            }
            }
            .sheet(item: $emailAuthMode) { mode in
                EmailAuthSheetView(mode: mode) { email, password, displayName in
                    switch mode {
                    case .signUp:
                        await sessionStore.createAccountWithEmail(
                            email: email,
                            password: password,
                            displayName: displayName,
                            preference: pref,
                            context: modelContext
                        )
                    case .signIn:
                        await sessionStore.signInWithEmail(
                            email: email,
                            password: password,
                            preference: pref,
                            context: modelContext
                        )
                    }
                }
            }
            .navigationDestination(isPresented: $showAccountSettingsHome) {
                AccountSettingsHomeView(
                    authEmail: pref.authEmail,
                    isReadOnlyMode: isReadOnlyMode,
                    onCreateAccount: {
                        emailAuthMode = .signUp
                    },
                    onSignInWithEmail: {
                        emailAuthMode = .signIn
                    },
                    onSignInWithGoogle: {
                        Task {
                            await sessionStore.signInWithGoogle(preference: pref, context: modelContext)
                        }
                    },
                    onSignOut: {
                        sessionStore.signOut(preference: pref, context: modelContext)
                    }
                )
            }
    }

    private var formWithAlerts: some View {
        formWithSheets
            .alert("Kunne ikke eksportere data", isPresented: $showExportError) {
            Button("OK", role: .cancel) { }
            } message: {
            Text(exportMessage.isEmpty ? "Prøv igjen litt senere." : exportMessage)
            }
            .alert("Kunne ikke importere data", isPresented: $showImportError) {
            Button("OK", role: .cancel) { }
            } message: {
            Text(importMessage.isEmpty ? "Kontroller filen og prøv igjen." : importMessage)
            }
            .alert("Import fullført", isPresented: $showImportSuccess) {
            Button("OK", role: .cancel) { }
            } message: {
            Text(importMessage)
            }
            .alert("Kunne ikke slette data", isPresented: $showDeleteAllError) {
            Button("OK", role: .cancel) { }
            } message: {
            Text("Prøv igjen litt senere.")
            }
            .alert("Konto slettet", isPresented: $showDeleteAccountSuccess) {
            Button("OK", role: .cancel) { }
            } message: {
            Text("Kontoen din er slettet, og appen er nullstilt lokalt.")
            }
            .alert(
                "Kunne ikke lagre innstilling",
                isPresented: Binding(
                    get: { settingsErrorMessage != nil },
                    set: { if !$0 { settingsErrorMessage = nil } }
                )
            ) {
            Button("OK", role: .cancel) {
                settingsErrorMessage = nil
            }
            } message: {
            Text(settingsErrorMessage ?? "")
            }
            .alert("Alle data er slettet", isPresented: $showDeleteAllSuccess) {
            Button("OK", role: .cancel) { }
            } message: {
            Text("Appen er nullstilt lokalt.")
            }
            .alert("Lastet demo", isPresented: $showDemoLoadSuccess) {
            Button("OK", role: .cancel) { }
            } message: {
            Text(demoLoadMessage)
            }
            .alert("Kunne ikke laste demo", isPresented: $showDemoLoadError) {
            Button("OK", role: .cancel) { }
            } message: {
            Text("Prøv igjen litt senere.")
            }
            .onChange(of: viewModel.preferencePersistenceErrorMessage) { _, newValue in
                guard let newValue else { return }
                settingsErrorMessage = newValue
                viewModel.clearPreferencePersistenceError()
            }
            .onChange(of: sessionStore.authErrorMessage) { _, newValue in
                guard let newValue else { return }
                settingsErrorMessage = newValue
                sessionStore.clearError()
            }
            .onAppear {
                openPendingSettingsRouteIfNeeded()
            }
            .onChange(of: navigationState.pendingSettingsRoute) { _, _ in
                openPendingSettingsRouteIfNeeded()
            }
    }

    private func openPendingSettingsRouteIfNeeded() {
        guard navigationState.selectedTab == .settings,
              let pendingRoute = navigationState.pendingSettingsRoute else {
            return
        }

        navigationState.pendingSettingsRoute = nil
        switch pendingRoute {
        case .account:
            showAccountSettingsHome = true
        }
    }

    private var settingsHomeSection: some View {
        Section {
            NavigationLink {
                AccountSettingsHomeView(
                    authEmail: pref.authEmail,
                    isReadOnlyMode: isReadOnlyMode,
                    onCreateAccount: {
                        emailAuthMode = .signUp
                    },
                    onSignInWithEmail: {
                        emailAuthMode = .signIn
                    },
                    onSignInWithGoogle: {
                        Task {
                            await sessionStore.signInWithGoogle(preference: pref, context: modelContext)
                        }
                    },
                    onSignOut: {
                        sessionStore.signOut(preference: pref, context: modelContext)
                    }
                )
            } label: {
                settingsRow(title: "Konto og synk", value: accountOverviewText(), showsChevron: false)
            }
            .buttonStyle(.plain)

            NavigationLink {
                EconomySettingsHomeView(
                    pref: pref,
                    isReadOnlyMode: isReadOnlyMode,
                    investmentBuckets: investmentBuckets
                )
            } label: {
                settingsRow(title: "Oppsett", value: "", showsChevron: false)
            }
            .buttonStyle(.plain)

            NavigationLink {
                AppSettingsHomeView(
                    pref: pref,
                    isReadOnlyMode: isReadOnlyMode,
                    appearanceModeBinding: appearanceModeBinding,
                    settingsErrorMessage: $settingsErrorMessage,
                    onPersistSettings: persistSettingsChanges,
                    onApplyReminderSettings: applyReminderSettings
                )
            } label: {
                settingsRow(title: "App", value: currentAppearanceMode.title, showsChevron: false)
            }
            .buttonStyle(.plain)

            NavigationLink {
                DataPrivacySettingsHomeView(
                    isReadOnlyMode: isReadOnlyMode,
                    storageLocationText: storageLocationText(),
                    storeModeText: storeModeText(),
                    storeModeDetailText: storeModeDetailText(),
                    isAuthenticated: sessionStore.isAuthenticated,
                    shouldShowDemoTools: viewModel.shouldShowDemoTools(),
                    onExport: {
                        resetExportPasswordState()
                        showExportPasswordSheet = true
                    },
                    importPickerIsPresented: $showImportPicker,
                    onSelectImportMode: beginImportSelection,
                    onImportResult: handleImport,
                    onConfirmDeleteAccount: {
                        Task {
                            if await sessionStore.deleteAccount(preference: pref, context: modelContext) {
                                showDeleteAccountSuccess = true
                            }
                        }
                    },
                    onConfirmDeleteAll: {
                        do {
                            try viewModel.deleteAllData(context: modelContext)
                            showDeleteAllSuccess = true
                        } catch {
                            showDeleteAllError = true
                        }
                    },
                    onLoadDemo: {
                        do {
                            let report = try viewModel.seedDemoRealisticYear(context: modelContext, year: nil)
                            demoLoadMessage = "Demo (3 år) lastet ✓\n\nMåneder: \(report.budgetMonths)\nTransaksjoner: \(report.transactions)\nSnapshots: \(report.snapshots)"
                            showDemoLoadSuccess = true
                            showToast("Demo (3 år) lastet ✓")
                        } catch {
                            showDemoLoadError = true
                        }
                    },
                    onLoadMarketingDemo: {
                        do {
                            let report = try viewModel.seedMarketingDemo(context: modelContext)
                            demoLoadMessage = "Marketing-demo lastet ✓\n\nMåneder: \(report.budgetMonths)\nTransaksjoner: \(report.transactions)\nSnapshots: \(report.snapshots)"
                            showDemoLoadSuccess = true
                            showToast("Marketing-demo lastet ✓")
                        } catch {
                            showDemoLoadError = true
                        }
                    },
                    onConfirmDemoWipe: {
                        do {
                            try viewModel.wipeAllDataForDemo(context: modelContext)
                            demoLoadMessage = "Alle lokale data er tømt."
                            showDemoLoadSuccess = true
                            showToast("Alle data tømt ✓")
                        } catch {
                            showDemoLoadError = true
                        }
                    }
                )
            } label: {
                settingsRow(title: "Data og personvern", value: storageLocationText(), showsChevron: false)
            }
            .buttonStyle(.plain)

            NavigationLink {
                AboutAppView()
            } label: {
                settingsRow(title: "Om appen", value: appVersionText(), showsChevron: false)
            }
            .buttonStyle(.plain)

            NavigationLink {
                FAQSettingsView()
            } label: {
                settingsRow(title: "Vanlige spørsmål", value: "", showsChevron: false)
            }
            .buttonStyle(.plain)
        }
    }

    private var homeLanguageSection: some View {
        Section {
            HStack(spacing: 12) {
                Spacer()
                homeLanguageFlag(flag: "🇳🇴", title: "Norsk", isSelected: true)
                Spacer()
            }
            .padding(.vertical, 2)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
        } header: {
            sectionHeader("Språk")
        }
    }

    private func homeLanguageFlag(flag: String, title: String, isSelected: Bool) -> some View {
        HStack(spacing: 8) {
            Text(flag)
                .font(.body)

            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)

            if isSelected {
                Spacer(minLength: 4)
                Image(systemName: "checkmark")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.primary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(minWidth: 112)
        .background(
            isSelected ? AppTheme.primary.opacity(0.08) : AppTheme.surface.opacity(0.9),
            in: Capsule()
        )
        .overlay(
            Capsule()
                .stroke(isSelected ? AppTheme.primary.opacity(0.28) : AppTheme.divider.opacity(0.9), lineWidth: 1)
        )
        .opacity(isSelected ? 1 : 0.78)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(isSelected ? "Aktivt språk" : "Ikke aktivt språk")")
    }

    private func showToast(_ message: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            demoToastMessage = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.easeInOut(duration: 0.2)) {
                demoToastMessage = nil
            }
        }
    }

    private func performExport() {
        let trimmedPassword = exportPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmation = exportPasswordConfirmation.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedPassword.isEmpty else {
            exportMessage = DataTransferError.passwordRequiredForEncryptedExport.localizedDescription
            showExportPasswordSheet = false
            showExportError = true
            return
        }
        guard trimmedPassword == trimmedConfirmation else {
            exportMessage = "Passordene må være like."
            showExportPasswordSheet = false
            showExportError = true
            return
        }

        do {
            let url = try viewModel.exportData(context: modelContext, password: trimmedPassword)
            shareItem = ShareURL(url)
            sharedExportURL = url
            exportMessage = ""
            resetExportPasswordState()
            showExportPasswordSheet = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 600) {
                if sharedExportURL == url {
                    cleanupSharedExportFile()
                }
            }
        } catch {
            exportMessage = error.localizedDescription
            showExportPasswordSheet = false
            showExportError = true
        }
    }

    private func cleanupSharedExportFile() {
        guard let url = sharedExportURL else { return }
        try? FileManager.default.removeItem(at: url)
        sharedExportURL = nil
        shareItem = nil
    }

    private func ensurePreference() {
        if let existing = preferences.first {
            ensuredPreference = existing
            return
        }
        guard ensuredPreference == nil else { return }
        ensuredPreference = viewModel.preference(from: preferences, context: modelContext)
    }

    private func persistSettingsChanges(syncReminder: Bool) {
        guard !isReadOnlyMode else {
            settingsErrorMessage = PersistenceWriteError.readOnlyMode.localizedDescription
            return
        }
        do {
            try viewModel.save(context: modelContext)
        } catch {
            settingsErrorMessage = (error as? LocalizedError)?.errorDescription ?? "Kunne ikke lagre endringen."
            return
        }

        guard syncReminder else { return }
        Task { @MainActor in
            do {
                try await viewModel.syncCheckInReminder(preference: pref)
            } catch {
                settingsErrorMessage = error.localizedDescription
            }
        }
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        guard case .success(let urls) = result else {
            if case .failure(let error) = result {
                importMessage = error.localizedDescription
                showImportError = true
            }
            return
        }

        guard let url = urls.first else { return }
        pendingImportURL = url
        importPassword = ""
        showImportPasswordSheet = true
    }

    private func beginImportSelection(mode: DataImportMode) {
        pendingImportMode = mode
        showImportModeDialog = false
        DispatchQueue.main.async {
            showImportPicker = true
        }
    }

    private func performImport() {
        guard !isReadOnlyMode else {
            importMessage = PersistenceWriteError.readOnlyMode.localizedDescription
            showImportError = true
            return
        }
        guard let url = pendingImportURL else { return }

        let didAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didAccess {
                url.stopAccessingSecurityScopedResource()
            }
            pendingImportURL = nil
        }

        do {
            let report = try viewModel.importData(
                from: url,
                mode: pendingImportMode,
                context: modelContext,
                password: normalizedImportPassword()
            )
            importMessage = importSuccessText(report)
            resetImportPasswordState()
            showImportPasswordSheet = false
            showImportSuccess = true
            Task { @MainActor in
                do {
                    try await viewModel.syncCheckInReminder(preference: pref)
                } catch {
                    settingsErrorMessage = error.localizedDescription
                }
            }
        } catch {
            importMessage = error.localizedDescription
            showImportPasswordSheet = false
            showImportError = true
        }
    }

    private func resetExportPasswordState() {
        exportPassword = ""
        exportPasswordConfirmation = ""
    }

    private func resetImportPasswordState() {
        importPassword = ""
    }

    private func normalizedImportPassword() -> String? {
        let trimmed = importPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func importSuccessText(_ report: DataImportReport) -> String {
        let backupLine = report.backupFileName.map { "\nBackup: \($0)" } ?? ""
        return "\(report.mode.title) fullført.\n\n" +
        "Måneder: \(report.budgetMonths)\n" +
        "Kategorier: \(report.categories)\n" +
        "Transaksjoner: \(report.transactions)\n" +
        "Snapshots: \(report.snapshots)" +
        backupLine
    }

    private var appearanceModeBinding: Binding<AppAppearancePreference> {
        Binding(
            get: { AppAppearancePreference(rawValue: appAppearanceModeRawValue) ?? .followSystem },
            set: { appAppearanceModeRawValue = $0.rawValue }
        )
    }

    private var currentAppearanceMode: AppAppearancePreference {
        AppAppearancePreference(rawValue: appAppearanceModeRawValue) ?? .followSystem
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

    private func reminderToggleSubtitle() -> String {
        pref.checkInReminderEnabled ? "Ber om varsling rundt den \(pref.checkInReminderDay). hver måned" : "Varsler er av"
    }

    private func accountOverviewText() -> String {
        sessionStore.isAuthenticated ? "Logget inn" : "Lokal bruk"
    }

    private func bucketSummaryText() -> String {
        let activeCount = investmentBuckets.filter { $0.isActive }.count
        if activeCount == 1 { return "1 aktiv" }
        return "\(activeCount) aktive"
    }

    private func applyReminderSettings(enabled: Bool, day: Int) {
        guard !isReadOnlyMode else {
            settingsErrorMessage = PersistenceWriteError.readOnlyMode.localizedDescription
            return
        }
        pref.checkInReminderEnabled = enabled
        pref.checkInReminderDay = max(1, min(28, day))
        pref.checkInReminderHour = 12
        pref.checkInReminderMinute = 0
        persistSettingsChanges(syncReminder: true)
    }

    private func appVersionText() -> String {
        let short = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(short) (Build \(build))"
    }

    private func storeModeText() -> String {
        switch SporOkonomiApp.activeStoreMode {
        case .primary:
            return "Lokal + iCloud"
        case .primaryWithoutCloud:
            return "Kun lokal"
        case .recovery:
            return "Recovery (lokal)"
        case .memoryOnly:
            return "Midlertidig"
        }
    }

    private func storageLocationText() -> String {
        isCloudSyncActive() ? "Lokalt + iCloud via Apple" : "Kun lagret lokalt"
    }

    private func isCloudSyncActive() -> Bool {
        SporOkonomiApp.activeStoreMode == .primary
    }

    private func storeModeDetailText() -> String? {
        switch SporOkonomiApp.activeStoreMode {
        case .primary:
            return nil
        case .primaryWithoutCloud:
            var detail = "iCloud-synk via Apple er ikke aktiv nå. Data lagres derfor bare på denne enheten."
            if let accountStatus = SporOkonomiApp.lastCloudAccountStatus, !accountStatus.isEmpty {
                detail += "\n\nKonto-status: \(accountStatus)"
            }
            if let probe = SporOkonomiApp.lastCloudProbeStatus, !probe.isEmpty {
                detail += "\n\nCloud probe: \(probe)"
            }
            if let analysis = SporOkonomiApp.lastCloudCompatibilityAnalysis, !analysis.isEmpty {
                detail += "\n\nCloud analyse: \(analysis)"
            }
            if let error = SporOkonomiApp.lastCloudInitError, !error.isEmpty {
                detail += "\n\nFeildetaljer: \(error)"
            }
            return detail
        case .recovery:
            var detail = "Primær lagring kunne ikke åpnes. Appen bruker en separat recovery-lagring på denne enheten."
            if let error = SporOkonomiApp.lastCloudInitError, !error.isEmpty {
                detail += "\n\nFeildetaljer: \(error)"
            }
            return detail
        case .memoryOnly:
            return "Appen kjører midlertidig uten varig lagring. Endringer kan ikke lagres permanent."
        }
    }

    private func binding<T>(_ keyPath: ReferenceWritableKeyPath<UserPreference, T>) -> Binding<T> {
        Binding(
            get: { pref[keyPath: keyPath] },
            set: {
                guard !isReadOnlyMode else {
                    settingsErrorMessage = PersistenceWriteError.readOnlyMode.localizedDescription
                    return
                }
                pref[keyPath: keyPath] = $0
                persistSettingsChanges(syncReminder: false)
            }
        )
    }

    @ViewBuilder
    private func sectionHeader(_ title: String, tone: SettingsSectionHeaderTone = .default, topPadding: CGFloat = 6) -> some View {
        Text(title)
            .font(.system(.subheadline, design: .rounded).weight(.semibold))
            .foregroundStyle(tone == .destructive ? AppTheme.negative : AppTheme.textSecondary)
            .textCase(nil)
            .padding(.top, topPadding)
    }
}

enum SettingsSectionHeaderTone {
    case `default`
    case destructive
}
