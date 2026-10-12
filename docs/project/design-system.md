# Designsystem

Spor økonomi bruker SwiftUI, et felles tema og noen delte UI-stiler.
[Produkt- og UI-reglene](../agents/product.md) beskriver designretningen.
Denne guiden beskriver det som er implementert.

## Farger

[AppTheme.swift](../../SporOkonomi/Shared/Utils/AppTheme.swift) er kilden for semantiske
farger: bakgrunn, overflater, tekst, primærhandlinger, status og investeringstyper.
Fargene velges automatisk for lyst og mørkt tema.
Bruk for eksempel `AppTheme.textSecondary` og `AppTheme.surface` fremfor lokale hex-verdier.

## Kort og avstander

[UIFormatting.swift](../../SporOkonomi/Shared/Utils/UIFormatting.swift) definerer:

| API | Bruk |
| --- | --- |
| `appCardStyle()` | Vanlig kort, padding 16, radius 16 og kantlinje |
| `appCardStyle(.hero)` | Hovedkort, padding 20, radius 28, gradient og skygge |
| `AppSpacing.section` | Standard seksjonsavstand på 12 |
| `AppSpacing.cardPadding` | Intern padding for vanlig kort, 16 |
| `AppSpacing.heroPadding` | Intern padding for hovedkort, 20 |

```swift
VStack(alignment: .leading, spacing: AppSpacing.section) {
    Text("Investeringer").appCardTitleStyle()
    Text("Ingen verdier registrert ennå").appSecondaryStyle()
}
.frame(maxWidth: .infinity, alignment: .leading)
.appCardStyle()
```

Kortmodifieren inkluderer intern padding. Plasser ytre skjermmarger utenfor kortet.
Behold innhold og informasjonsprioritet i den enkelte feature.
Stilene brukes i Oversikt og hero-/detaljkort i Investeringer; resten av appen er ikke fullt migrert.

## Tekst, felt og handlinger

Delte stiler i samme fil:

- `appBigNumberStyle()` for hovedtall, med semibold systemtypografi og tabellsifre
- `appCardTitleStyle()` for korttitler
- `appBodyStyle()` for brødtekst
- `appSecondaryStyle()` for metadata og hjelpetekst
- `appProminentCTAStyle(tone:)` for primærknapper med primær eller positiv tone
- `.textFieldStyle(.appInput)` for tekstfelt
- `appInputShellStyle()` for tilsvarende ramme rundt andre inputkontroller

Noen skjermer bruker fortsatt egne tekststørrelser og knapper.
Bruk eksisterende stiler når de passer; avklar nye varianter ut fra funksjonelt behov.

## Previews og visuell kontroll

Åpne `UIFormatting.swift` i Xcode og bruk Canvas til kortpreviewene:

- «Kort – lyst»
- «Kort – mørkt, stor tekst» med Dynamic Type på `accessibility3`

Previewene viser representative kort, ikke komplette skjermer.
Ved UI-endringer kontroller også berørte skjermer med tomme og realistiske data,
lyst/mørkt tema og stor tekst. Sjekk avkutting, handlingshierarki og tilgjengelighetslabels.
