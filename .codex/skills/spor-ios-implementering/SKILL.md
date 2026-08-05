---
name: spor-ios-implementering
description: Bruk denne skillen når du skal endre Swift, SwiftUI, SwiftData, ViewModels, services, navigasjon eller appkode i Spor økonomi.
---

# Spor iOS-Implementering

## Før Kode

1. Les `AGENTS.md`.
2. Les relevante deler av `docs/agents/workflow.md` og `docs/agents/safe-change-rules.md`.
3. Identifiser berørte filer før endring.
4. Avklar hvis flere tolkninger gir ulik produktoppførsel.

## Arkitektur

- Plattform: iOS med SwiftUI.
- Lagring: SwiftData, offline-first.
- Arkitektur: MVVM per feature.
- View og ViewModel skal ligge i samme featuremappe.
- Forretningslogikk skal ligge i ViewModel eller Service.
- Generiske helpers skal ligge i `SporOkonomi/Shared/Utils/`.
- Domenelogikk skal ligge i `SporOkonomi/Domain/`.

## SwiftUI-Regler

- Views er presentasjonslag.
- Unngå kompleks logikk i `body`.
- Flytt beregninger til ViewModel eller computed properties.
- Bruk `@State` for lokal UI-state.
- Bruk `@StateObject` for ViewModel-eierskap.
- Bruk `@Environment` kun når nødvendig.
- Bruk `Button` eller `NavigationLink` for handlinger og navigasjon.

## Implementasjon

- Gjør minste komplette endring.
- Bevar eksisterende designsystem og `AppTheme`.
- Ikke introduser dependencies uten eksplisitt forespørsel.
- Dataoperasjoner som oppretter automatisk innhold skal være idempotente.
- Ikke endre SwiftData-modeller eller schema uten tydelig behov og migrasjonsvurdering.

## Tester Og Verifikasjon

Skriv tester når endringen berører:
- forretningslogikk
- dato-regler
- import/eksport
- onboarding
- mål
- challenges
- faste poster
- dataflyt på tvers av lag

Bygg når:
- ViewModel, service, navigasjon, nye typer, modeller eller dataflyt endres.

Rapporter:
- endrede filer og hvorfor
- compile-risk: lav, medium eller høy
- hva som ble verifisert
- hva som ikke ble verifisert
