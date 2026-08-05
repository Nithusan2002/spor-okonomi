# AGENTS.md

Arbeidskontrakt for Codex i prosjektet **Spor økonomi**.

Mål:
- høy fart
- tydelig kvalitet
- små, trygge leveranser

## Før du starter

- Les denne filen først.
- Velg riktig lokal skill i `.codex/skills/` når oppgaven matcher.
- Hold scope smalt. Ikke refaktorer bredt uten eksplisitt avklart leveranse.
- UI/copy skal være norsk.
- Ikke introduser nye dependencies uten eksplisitt forespørsel.

## Delt Kontekst I Notion

Før en oppgave som gjelder boligsøk, jobbsøknader, Radio Nova, Avarn eller sideinntekt:
- søk i Notion etter siden `Codex — delt kontekst`
- les relevant seksjon eller database før du svarer
- når noe er avklart eller endret i disse temaene, oppdater samme side eller riktig rad

## Prosjektkontekst

- Plattform: iOS med SwiftUI
- Lagring: SwiftData, offline-first
- Arkitektur: MVVM per feature
- Domene: budsjett, investeringer, mål og enkel økonomisk oversikt
- Bankintegrasjon: ikke i MVP

## Kjerneprinsipper

- Gjør minste komplette endring som løser oppgaven.
- Bevar eksisterende designsystem, navngiving og formattering.
- Hold forretningslogikk i ViewModel eller Service, ikke i View.
- Ikke bland flere temaer i samme commit.
- Ikke endre SwiftData-modeller, schema eller persistens uten tydelig behov.
- Hvis flere tolkninger gir ulik produktoppførsel: stopp og spør.

## Prosjektstruktur

Appkode ligger feature-basert:

```text
SporOkonomi/
  App/
  Domain/
    Models/
    Services/
  Features/
    Budget/
    Investments/
    Overview/
    Settings/
  Shared/
    Utils/
```

Regler:
- View og ViewModel ligger i samme featuremappe.
- Feature-spesifikk UI deles i samme featuremappe.
- Generiske helpers ligger i `SporOkonomi/Shared/Utils/`.
- Domenelogikk ligger i `SporOkonomi/Domain/`.
- Ikke lag nye toppnivåmapper uten eksplisitt grunn.

## Lokale Skills

Bruk disse når oppgaven matcher:

- `.codex/skills/spor-ios-implementering/SKILL.md` for SwiftUI, SwiftData, ViewModel, services og appkode.
- `.codex/skills/spor-design/SKILL.md` for UX, skjermstruktur, mikrocopy og UI-konsistens.
- `.codex/skills/spor-qa/SKILL.md` for review, teststrategi, release-sjekk og kvalitetssikring.
- `.codex/skills/spor-growth/SKILL.md` for App Store-copy, onboarding, aktivering og veksteksperimenter.

## Standard Arbeidsflyt

1. Avklar mål og akseptansekriterier når de ikke er tydelige.
2. Identifiser berørte filer før endring.
3. Implementer minste komplette løsning.
4. Verifiser med riktig nivå av build/test/manuell QA.
5. Rapporter hva som ble verifisert og hva som ikke ble verifisert.
6. Commit kun når oppgaven ber om det eller Definition of Done krever det.

## Test- Og Build-Policy

- Logikkendringer, dato-regler, import/eksport, onboarding, mål, challenges og faste poster skal ha tester.
- Bugfix i logikk skal helst starte med reproduksjonstest.
- Bygg når ViewModel, services, navigasjon, modeller, nye typer eller dataflyt endres.
- Ikke bygg for rene copy-endringer eller små dokumentasjonsendringer.

## Commit-Standard

Format:

```text
<type>(<scope>): <kort beskrivelse>
```

Typer:
- `feat`
- `fix`
- `refactor`
- `test`
- `docs`
- `chore`

Eksempler:
- `feat(budget): innfør gruppegrenser med enkel setup-sheet`
- `fix(investments): hindre duplikat snapshot ved samme periodKey`
- `refactor(overview): flytt beregninger til viewmodel`
- `docs(agents): stram inn arbeidskontrakt`

## Definition Of Done

En oppgave er ferdig når:
- funksjonen virker som spesifisert
- ingen nye build-feil er introdusert
- relevante tomtilstander er håndtert
- dark mode og light mode er vurdert for UI-endringer
- relevante tester er lagt til eller bevisst utelatt med forklaring
- verifikasjonsstatus er rapportert

## Detaljerte Referanser

- `docs/agents/product.md` for produktmål, posisjonering og UI-konsistens.
- `docs/agents/workflow.md` for arbeidsflyt, TDD, build-policy og leveranseformat.
- `docs/agents/safe-change-rules.md` for scope-kontroll og trygg endring.
- `docs/agents/agent-roles.md` for Designer-, iOS-, QA-, Release- og Growth-agent.
