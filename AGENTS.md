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

Prosjektets skills er førstevalg. `.codex/skills/` er kilden; `.agents/skills/` peker til samme katalog for oppdagelse som i MatLogg. Last bare skills som er relevante for oppgaven.

| Arbeid | Skill |
| --- | --- |
| Ny funksjon, endret scope eller større brukerflyt | `spor-produkt` |
| UX, mikrocopy, skjermstruktur og designsystem | `spor-design` |
| SwiftUI, ViewModel, services, navigasjon og appkode | `spor-ios-implementering` |
| Budsjett, sparing, investeringer, faste poster og datoregler | `spor-okonomilogikk` |
| SwiftData, import/eksport, reset, seeding og migrasjoner | `spor-data` |
| Konto, Supabase-auth, kontosletting, AI-deling og personvern | `spor-auth-personvern` |
| Review, regresjoner, tester og kvalitetssikring | `spor-qa` |
| TestFlight, App Store og release readiness | `spor-release` |
| App Store-copy, aktivering og veksteksperimenter | `spor-growth` |

Skill-filen ligger i `.codex/skills/<skill-navn>/SKILL.md`.

## Agentroller og samarbeid

Velg fagrolle etter oppgaven fra `docs/agents/agent-roles.md`. Rollene er arbeidsinstruksjoner; de oppretter ikke egne agenter automatisk.

- Små oppgaver løses av én agent med relevante skills.
- Bruk underagenter når brukeren ber om delegering eller parallelt agentarbeid. Gi hver agent avgrenset scope, berørte filer og ønsket verifikasjon.
- Ved parallelt arbeid skal én agent eie integrasjonen. Unngå samtidig redigering av samme filer; formidle funn, antakelser og testresultater ved overlevering.
- Produktendring: produkt → design ved behov → relevante fag-skills → implementering → QA.
- Dataendring: data → økonomilogikk/auth ved behov → implementering → målrettede tester.
- Release: relevante fag-skills → QA → releasevurdering.

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
- `docs/agents/agent-roles.md` for produkt-, design-, iOS-, økonomi-, data-, auth/personvern-, QA-, release- og growth-roller.
