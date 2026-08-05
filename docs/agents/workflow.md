# Arbeidsflyt

## Standardflyt

1. Design: klargjør mål, brukerflyt, edge cases, tomtilstander og mikrocopy.
2. Implementasjon: gjør minste komplette endring og hold logikk i ViewModel eller Service.
3. QA: verifiser build, regressjoner, tomtilstander, dark mode, light mode og tilgjengelighet når relevant.
4. Commit: ett tema per commit med presis commit-melding.

Akseptansekriterier skal være låst før kode når oppgaven endrer produktoppførsel.

## AI-Sikker Arbeidsflyt

Skriv tester før implementasjon når oppgaven endrer:
- forretningslogikk
- dato-regler
- import/eksport
- onboarding
- mål
- challenges
- faste poster

Ved bugfix:
1. skriv test som reproduserer feilen
2. verifiser at testen feiler
3. implementer fix

## TDD-Regel

Red:
Test beskriver ønsket oppførsel og feiler.

Green:
Implementer minste kode for å få testen grønn.

Refactor:
Rydd kode uten å endre oppførsel.

Ikke endre eksisterende tester uten å forklare hvorfor.

## Obligatoriske QA-Sjekkpunkter

Alle relevante endringer skal vurdere:
- build-status
- tomtilstand
- 0-data
- dark mode
- light mode
- tilgjengelighet
- dato-kanttilfeller
- idempotens

## Testkrav Per Type Endring

UI-copy eller layout:
- manuell QA

ViewModel eller service-logikk:
- enhetstest

Bugfix:
- reproduksjonstest

Import/eksport, onboarding, reminders, mål, challenges eller faste poster:
- tester obligatoriske

Dataflyt på tvers av lag:
- integrasjonstest eller smoke-test

## Build-Policy

Ikke bygg Xcode-prosjektet for:
- rene copy-endringer
- dokumentasjonsendringer
- små isolerte spacing- eller fargejusteringer med lav compile-risiko

Bygg prosjektet når:
- ViewModel er endret
- SwiftData-modeller eller schema er endret
- navigasjon er endret
- nye filer eller nye typer er introdusert
- avhengigheter mellom filer er endret
- logikk for beregninger eller dataflyt er endret

Før build vurderes skal agenten:
- gjøre compile-risk-vurdering
- sjekke åpenbare typefeil, manglende imports, ugyldige kall, rename-konflikter og binding-feil
- rapportere om endringen virker lav, medium eller høy risiko

## Leveranseformat

Svar kort og konkret med:
- plan når oppgaven er større enn en enkel endring
- endrede filer og hvorfor
- kort forklaring på hva som ble gjort
- verifikasjon
- hva som ikke ble verifisert
- hvorfor prosjektet ikke ble bygget når build er utelatt
