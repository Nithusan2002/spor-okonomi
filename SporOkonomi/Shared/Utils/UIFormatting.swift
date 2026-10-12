import Foundation
import SwiftUI
import UIKit

// Felles mål for kort og seksjoner. Feature-spesifikt innhold beholder egen layout.
enum AppSpacing {
    static let section: CGFloat = 12
    static let cardPadding: CGFloat = 16
    static let heroPadding: CGFloat = 20
}

enum AppCardStyle {
    case standard
    case hero

    var cornerRadius: CGFloat {
        switch self {
        case .standard: return 16
        case .hero: return 28
        }
    }
}

private struct AppCardModifier: ViewModifier {
    let style: AppCardStyle

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
        switch style {
        case .standard:
            content
                .padding(AppSpacing.cardPadding)
                .background(AppTheme.surface, in: shape)
                .overlay(shape.stroke(AppTheme.divider, lineWidth: 1))
        case .hero:
            content
                .padding(AppSpacing.heroPadding)
                .background(
                    LinearGradient(
                        colors: [AppTheme.surface, AppTheme.primary.opacity(0.08), AppTheme.surfaceElevated],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: shape
                )
                .overlay(shape.stroke(AppTheme.divider.opacity(0.8), lineWidth: 1))
                .shadow(color: AppTheme.primary.opacity(0.08), radius: 24, y: 14)
        }
    }
}

enum AppProminentCTATone {
    case primary
    case positive
}

enum AppDateFormatters {
    static let fullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nb_NO")
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()

    static let monthYearShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nb_NO")
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()

    static let monthName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nb_NO")
        formatter.dateFormat = "MMMM"
        return formatter
    }()
}

struct AppInputFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.body)
            .foregroundStyle(AppTheme.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(AppTheme.surfaceElevated, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.divider, lineWidth: 1)
            )
    }
}

func formatNOK(_ value: Double) -> String {
    value.formatted(.currency(code: "NOK"))
}

func formatPercent(_ value: Double) -> String {
    value.formatted(.percent.precision(.fractionLength(1)))
}

func clampedProgress(value: Double, total: Double) -> (value: Double, total: Double) {
    let safeTotal = max(total, 1)
    let safeValue = min(max(value, 0), safeTotal)
    return (safeValue, safeTotal)
}

func formatDate(_ date: Date) -> String {
    AppDateFormatters.fullDate.string(from: date)
}

func formatMonthYearShort(_ date: Date) -> String {
    AppDateFormatters.monthYearShort.string(from: date)
}

func formatMonthName(_ date: Date) -> String {
    AppDateFormatters.monthName.string(from: date)
}

func formatPeriodKeyAsDate(_ periodKey: String) -> String {
    let parts = periodKey.split(separator: "-")
    guard parts.count == 2,
          let year = Int(parts[0]),
          let month = Int(parts[1]),
          (1...12).contains(month) else {
        return periodKey
    }
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = 1
    let date = Calendar.current.date(from: components) ?? .now
    return formatDate(date)
}

extension View {
    /// Inkluderer intern padding, bakgrunn og kantlinje.
    func appCardStyle(_ style: AppCardStyle = .standard) -> some View {
        modifier(AppCardModifier(style: style))
    }

    func appBigNumberStyle() -> some View {
        self
            .font(.system(.largeTitle, design: .default).weight(.semibold))
            .monospacedDigit()
    }

    func appCardTitleStyle() -> some View {
        self.font(.headline.weight(.semibold))
    }

    func appBodyStyle() -> some View {
        self.font(.subheadline)
    }

    func appSecondaryStyle() -> some View {
        self
            .font(.footnote)
            .foregroundStyle(AppTheme.textSecondary)
    }

    func appCoachStyle() -> some View {
        self
            .font(.system(.title3, design: .rounded).weight(.semibold))
            .monospacedDigit()
    }

    func appCTAStyle() -> some View {
        self.font(.headline.weight(.semibold))
    }

    func appProminentCTAStyle(tone: AppProminentCTATone = .primary) -> some View {
        let tintColor: Color
        let foregroundColor: Color

        switch tone {
        case .primary:
            tintColor = AppTheme.primary
            foregroundColor = AppTheme.onPrimary
        case .positive:
            tintColor = AppTheme.positive
            foregroundColor = AppTheme.onPositive
        }

        return self
            .appCTAStyle()
            .buttonStyle(.borderedProminent)
            .tint(tintColor)
            .foregroundStyle(foregroundColor)
    }

    func appInputShellStyle() -> some View {
        self
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(AppTheme.surfaceElevated, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.divider, lineWidth: 1)
            )
    }

    func appKeyboardDismissToolbar() -> some View {
        self.modifier(AppKeyboardDismissToolbarModifier())
    }
}

extension TextFieldStyle where Self == AppInputFieldStyle {
    static var appInput: AppInputFieldStyle { AppInputFieldStyle() }
}

private struct AppKeyboardDismissToolbarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3.weight(.semibold))
                }
                .accessibilityLabel("Lukk tastatur")
            }
        }
    }
}

private struct AppCardStylesPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("Min formue").appSecondaryStyle()
                    Text("125 000 kr").appBigNumberStyle()
                    Text("Oppdatert denne måneden").appSecondaryStyle()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCardStyle(.hero)

                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("Ingen registreringer ennå").appCardTitleStyle()
                    Text("Legg til en inntekt eller utgift for å komme i gang.")
                        .appBodyStyle()
                    Button("Legg til registrering") {}
                        .appProminentCTAStyle()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCardStyle()
            }
            .foregroundStyle(AppTheme.textPrimary)
            .padding(AppSpacing.cardPadding)
        }
        .background(AppTheme.background)
    }
}

#Preview("Kort – lyst") {
    AppCardStylesPreview().preferredColorScheme(.light)
}

#Preview("Kort – mørkt, stor tekst") {
    AppCardStylesPreview()
        .preferredColorScheme(.dark)
        .environment(\.dynamicTypeSize, .accessibility3)
}
