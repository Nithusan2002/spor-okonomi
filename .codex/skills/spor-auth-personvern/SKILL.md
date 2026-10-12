---
name: spor-auth-personvern
description: Arbeid med valgfri konto, Supabase-auth, session-flyt, kontosletting, AI-deling og personvern i Spor økonomi.
---

# Konto og personvern

Les berørt flyt i `SporOkonomi/App/SessionStore.swift`, `AppRootViewModel.swift` og `SporOkonomi/Domain/Services/SupabaseAuthService.swift`. Ved serverendringer les aktuell funksjon i `supabase/functions/`; ved AI-deling les også `AIInsightsService.swift`. Konto innebærer ikke automatisk at økonomidata synkroniseres; bekreft faktisk dataflyt før du beskriver den.

Bevar lokal bruk uten konto. Vurder utløpt session, nettverksfeil, utlogging og forskjellen mellom lokal datasletting og sletting av ekstern konto. Serverfunksjoner skal verifisere identitet og tilgang; ikke stol på en klientoppgitt bruker-ID.

Ikke legg tokens, hemmeligheter, persondata eller ekte økonomidata i repoet, logger eller testfixtures. Vurder hvilke data som sendes ut av enheten, hva brukeren får vite, og hvilke valg som finnes. Ikke introduser ekstern AI-deling som sideeffekt av en lokal funksjon.

Ved endret databruk: sammenlign `SporOkonomi/PrivacyInfo.xcprivacy`, `docs/legal/` og publiserte personvernsider med faktisk oppførsel. Oppdater bare relevante tekster og skill faktiske tekniske forhold fra juridiske vurderinger.

Bruk `SporOkonomiTests/AuthSessionTests.swift` og relevante onboarding-/root-tester. Test berørt serverflyt uten produksjonsdata. Lokal implementering og review innebærer ikke autorisasjon til deploy eller sletting av ekte kontoer.
