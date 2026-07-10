import SwiftUI

struct StorageDiagnosticsView: View {
    let storageLocationText: String
    let storeModeText: String
    let storeModeDetailText: String?
    let isReadOnlyMode: Bool

    var body: some View {
        List {
            Section("Lagring") {
                infoRow(title: "Lagring", value: storageLocationText)
                infoRow(title: "Lagringsmodus", value: storeModeText)
                Text("Lokal lagring er alltid utgangspunktet. Hvis iCloud er tilgjengelig, brukes den via Apple-kontoen din.")
                    .appSecondaryStyle()
            }

            if isReadOnlyMode {
                Section {
                    Text("Appen kjører i midlertidig lagring. Skrivende handlinger er derfor deaktivert til normal lagring er tilbake.")
                }
            }

            if let storeModeDetailText, !storeModeDetailText.isEmpty {
                Section("Diagnose") {
                    Text(storeModeDetailText)
                        .appSecondaryStyle()
                }
            }
        }
        .navigationTitle("Lagring og synk")
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .appBodyStyle()
            Spacer(minLength: 12)
            Text(value)
                .appSecondaryStyle()
                .multilineTextAlignment(.trailing)
        }
    }
}

struct AppearanceSettingsView: View {
    @Binding var selection: AppAppearancePreference

    var body: some View {
        List {
            Section {
                ForEach(AppAppearancePreference.allCases, id: \.rawValue) { mode in
                    Button {
                        selection = mode
                    } label: {
                        HStack {
                            Text(mode.title)
                                .appBodyStyle()
                            Spacer()
                            if selection == mode {
                                Image(systemName: "checkmark")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(AppTheme.primary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Visning")
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 86)
                .allowsHitTesting(false)
        }
    }
}

struct FAQSettingsView: View {
    private struct FAQItem: Identifiable {
        let id: String
        let question: String
        let answer: String
    }

    private struct FAQSection: Identifiable {
        let id: String
        let title: String
        let items: [FAQItem]
    }

    private let sections: [FAQSection] = [
        FAQSection(
            id: "privacy",
            title: "Data og personvern",
            items: [
                FAQItem(
                    id: "storage",
                    question: "Hvor lagres dataene mine?",
                    answer: "Som standard lagres data lokalt på denne enheten. Hvis iCloud er aktiv, kan de også synkes via Apple-kontoen din."
                ),
                FAQItem(
                    id: "account",
                    question: "Må jeg ha konto for å bruke appen?",
                    answer: "Nei. Du kan bruke appen lokalt uten konto og legge til konto senere hvis du vil."
                ),
                FAQItem(
                    id: "with-account",
                    question: "Hva skjer hvis jeg bruker konto?",
                    answer: "Konto brukes til innlogging og gjenoppretting. iCloud-synk styres fortsatt separat av Apple på enheten din."
                ),
                FAQItem(
                    id: "tracking",
                    question: "Bruker appen sporing eller annonsering?",
                    answer: "Nei. Spor økonomi bruker ikke annonser, tredjepartssporing eller bankkoblinger."
                ),
                FAQItem(
                    id: "export-delete",
                    question: "Hvordan fungerer eksport og sletting?",
                    answer: "Du kan eksportere data som en fil fra Data og personvern. Du kan også slette lokale data derfra hvis du vil rydde eller starte på nytt."
                ),
                FAQItem(
                    id: "permissions",
                    question: "Hvilke tillatelser kan appen be om?",
                    answer: "Varsler brukes bare til månedlig innsjekk hvis du slår dem på. Face ID brukes bare til å låse opp appen på denne enheten hvis du aktiverer det."
                )
            ]
        ),
        FAQSection(
            id: "product",
            title: "Bruk av appen",
            items: [
                FAQItem(
                    id: "bank",
                    question: "Må jeg koble til banken min?",
                    answer: "Nei. Spor økonomi fungerer uten bankkobling. Du legger inn inntekter, utgifter og verdier selv."
                ),
                FAQItem(
                    id: "available",
                    question: "Hva betyr \"Tilgjengelig denne måneden\"?",
                    answer: "Det er beløpet du har igjen å bruke denne måneden basert på det du har lagt inn så langt."
                ),
                FAQItem(
                    id: "limits",
                    question: "Må jeg sette budsjettgrenser for å bruke appen?",
                    answer: "Nei. Du kan føre transaksjoner uten grenser. Grenser gir bare mer oversikt i budsjettet."
                ),
                FAQItem(
                    id: "investments",
                    question: "Hvordan fungerer investeringer i appen?",
                    answer: "Du legger inn samlet verdi når du vil oppdatere utviklingen. Appen følger verdiene over tid, men henter ikke live-data."
                )
            ]
        )
    ]

    @State private var expandedQuestionID: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(section.title)
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(AppTheme.textPrimary.opacity(0.78))
                            .padding(.horizontal, 4)
                            .padding(.top, index == 0 ? 8 : 12)

                        VStack(spacing: 0) {
                            ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
                                VStack(spacing: 0) {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            expandedQuestionID = expandedQuestionID == item.id ? nil : item.id
                                        }
                                    } label: {
                                        HStack(alignment: .top, spacing: 12) {
                                            Text(item.question)
                                                .font(.subheadline.weight(.medium))
                                                .foregroundStyle(AppTheme.textPrimary)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)

                                            Image(systemName: expandedQuestionID == item.id ? "chevron.up" : "chevron.down")
                                                .font(.caption2.weight(.medium))
                                                .foregroundStyle(AppTheme.textSecondary.opacity(0.58))
                                                .padding(.top, 3)
                                        }
                                        .padding(.vertical, 12)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)

                                    if expandedQuestionID == item.id {
                                        Text(item.answer)
                                            .appSecondaryStyle()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.bottom, 10)
                                    }
                                }

                                if index < section.items.count - 1 {
                                    Divider()
                                        .padding(.leading, 2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 22))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(AppTheme.divider, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(AppTheme.background)
        .navigationTitle("Vanlige spørsmål")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutAppView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.colorScheme) private var colorScheme

    private var versionText: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var websiteURL: URL? {
        URL(string: "https://nithusan.no/spor-okonomi/")
    }

    private var heroAssetName: String {
        colorScheme == .dark ? "About-AppIcon-Dark" : "About-AppIcon-Light"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 14) {
                    Image(heroAssetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 152)
                        .accessibilityHidden(true)

                    VStack(spacing: 6) {
                        Text("Spor økonomi")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.textPrimary)
                            .multilineTextAlignment(.center)
                        Text("Få kontroll på økonomien din uten stress")
                            .appBodyStyle()
                            .foregroundStyle(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: 320)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 2)

                aboutCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Hva appen er laget for")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(AppTheme.textPrimary)
                        Text("Spor økonomi gir deg enkel oversikt over inntekter, utgifter, sparing og investeringer – uten bankkoblinger eller kompliserte oppsett.")
                            .appBodyStyle()
                            .foregroundStyle(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                aboutCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Trygg og enkel økonomioversikt")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(AppTheme.textPrimary)

                        VStack(alignment: .leading, spacing: 12) {
                            aboutTrustRow(
                                icon: "externaldrive.badge.checkmark",
                                text: "Data lagres lokalt først"
                            )
                            aboutTrustRow(
                                icon: "building.columns",
                                text: "Ingen banktilgang kreves"
                            )
                            aboutTrustRow(
                                icon: "slider.horizontal.3",
                                text: "Full kontroll på dine egne tall"
                            )
                        }
                    }
                }

                aboutCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Trenger du hjelp?")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(AppTheme.textPrimary)

                        Button {
                            if let url = URL(string: "mailto:sporokonomi.app@gmail.com") {
                                openURL(url)
                            }
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("sporokonomi.app@gmail.com")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(AppTheme.textPrimary)
                                    Text("Send spørsmål, forslag eller tilbakemelding.")
                                        .appSecondaryStyle()
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                            .padding(16)
                            .background(AppTheme.surfaceElevated.opacity(0.65), in: RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(AppTheme.divider.opacity(0.75), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                aboutWebsiteCard
                aboutInfoCard
            }
            .padding(.horizontal, 16)
            .padding(.top, 28)
            .padding(.bottom, 24)
        }
        .background(AppTheme.background)
        .navigationTitle("Om appen")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func aboutCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(17)
            .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(AppTheme.divider.opacity(0.8), lineWidth: 1)
            )
            .shadow(color: AppTheme.primary.opacity(0.05), radius: 16, x: 0, y: 6)
    }

    private func aboutTrustRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.primary)
                .frame(width: 20)

            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }

    private var aboutInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            aboutInfoRow(title: "Versjon", value: versionText)
            aboutInfoRow(title: "Lagring", value: "Lokal først")
            aboutInfoRow(title: "Plattform", value: "iPhone")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 17)
        .padding(.vertical, 15)
        .background(AppTheme.surface.opacity(0.78), in: RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(AppTheme.divider.opacity(0.55), lineWidth: 1)
        )
    }

    private var aboutWebsiteCard: some View {
        Group {
            if let websiteURL {
                Link(destination: websiteURL) {
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text("Nettside")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(AppTheme.textSecondary)

                        Spacer(minLength: 12)

                        Text("Spor økonomi")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(AppTheme.primary)

                        Image(systemName: "arrow.up.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 17)
                    .padding(.vertical, 15)
                    .background(AppTheme.surface.opacity(0.78), in: RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(AppTheme.divider.opacity(0.55), lineWidth: 1)
                    )
                }
                .accessibilityLabel("Nettside, Spor økonomi")
            }
        }
    }

    private func aboutInfoRow(title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppTheme.textSecondary)
            Spacer(minLength: 12)
            Text(value)
                .font(.footnote.weight(.medium))
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
