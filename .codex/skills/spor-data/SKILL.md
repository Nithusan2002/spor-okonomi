---
name: spor-data
description: Endre SwiftData-lagring, import/eksport, datareset, seeding og datamigrasjoner i Spor økonomi.
---

# Lokal lagring og dataoverføring

Les berørte modeller, `SporOkonomi/Domain/Services/PersistenceGate.swift` og lagringsoppsettet i `SporOkonomi/App/SporOkonomiApp.swift`. Ved import/eksport, les `SettingsDataTransferService.swift`, `SettingsDataTransferModels.swift` og `SettingsViewModel.swift` i `SporOkonomi/Features/Settings/` samt `SporOkonomiTests/SettingsImportTests.swift`.

Bevar offline-first og skillet mellom varig lagring og memory-only/read-only-modus. Bruk eksisterende `guardedSave` der flyten bruker lagringsporten; ikke omgå den for å skjule en skrivefeil. Vis feil uten å melde at data er lagret når save feiler.

Ved import: vurder formatversjon, ugyldige felt, referanser mellom modeller, duplikater og forskjellen mellom merge og replace. Valider før destruktive steg og vurder rollback ved feil midt i operasjonen. Bevar onboarding- og brukerpreferanser etter den avklarte importmodusen.

Ved schemaendring: beskriv kompatibilitet og migrasjon av eksisterende data. Test med isolert container gjennom `SporOkonomiTests/TestModelContainerFactory.swift`; bruk aldri brukerens ekte lagring som testdata. Seeding og automatisk opprettelse skal være idempotent.

Kjør tester for berørt import-, lagrings- eller seedingflyt og bygg ved modell-/dataflytendringer. Rapporter datatapsrisiko og uverifiserte migrasjoner konkret.
