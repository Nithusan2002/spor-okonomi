---
name: spor-release
description: Vurder TestFlight- og App Store-klargjøring, release-blokkere, metadata og faktisk verifikasjon i Spor økonomi.
---

# Release

Les `docs/project/release-readiness.md`, `INTERNAL_TESTING.md` og `AppStoreConnect-metadata.md` sammen med aktuell diff. Bruk `spor-qa` for feil og tester og `spor-growth` bare når copy eller posisjonering inngår.

Vurder de berørte kritiske flytene: første oppstart, lokal bruk, konto, registrering, månedsskifte, import/eksport og lagringsfeil. Kontroller release-konfigurasjon, demo-/debug-verktøy, tillatelser og at personvern- og App Store-tekst beskriver faktisk adferd. Bevar eventuell tilsiktet sandbox/TestFlight-tilgang til demo-verktøy.

Skill bekreftede blokkere fra forbedringer som kan vente. Oppgi gjennomførte kontroller med resultat og miljø, uverifiserte områder og en begrunnet go/no-go-anbefaling. Ikke gi go bare fordi en sjekkliste finnes; en build bekrefter heller ikke manuell simulator-/enhetstest.

Hold releasearbeid til stabilisering innen avtalt scope. Opplasting, publisering og produksjonsdeploy krever at det inngår i brukerens autoriserte oppgave.
