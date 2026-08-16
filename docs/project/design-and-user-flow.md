# Design Og Brukerflyt

## Designretning

Spor økonomi skal føles:
- enkel
- rolig
- tydelig
- rask

UI skal være norsk, lavmælt og konsekvent. Se `docs/agents/product.md` for detaljerte UI-regler.

## Hovedflyt

1. Bruker åpner appen.
2. Bruker går gjennom kort onboarding.
3. Bruker velger lokal bruk eller konto.
4. Bruker lander på Oversikt.
5. Bruker legger inn første transaksjon eller budsjettdata.
6. Bruker ser hva som er igjen denne måneden.

## Hovedskjermer

### Oversikt

Formål:
- gi rask status
- vise hva som er viktig nå
- samle måned, sparing og mål uten å bli en rapportskjerm

Krav:
- ett tydelig hovedtall eller hovedstatus
- forståelig tomtilstand
- ikke duplisere detaljnivå fra Budsjett og Investeringer

### Budsjett

Formål:
- registrere og justere månedens økonomi
- vise grupper, poster og gjenstående beløp

Krav:
- rask registrering
- tydelig skille mellom inntekt, utgift og sparing
- faste poster skal være forståelige

### Investeringer

Formål:
- gi manuell oversikt over utvikling
- støtte månedlige snapshots

Krav:
- ikke antyde automatisk kursdata
- gjøre historikk lett å skanne
- skille investeringer fra månedlig budsjett

### Innstillinger

Formål:
- håndtere konto, personvern, eksport/import og appvalg

Krav:
- administrative valg skal være rolige og tydelige
- personvern og dataflytting skal ikke gjemmes
- debug/demo-verktøy må gates riktig

## Tomtilstander

Alle tomtilstander skal svare kort på:
- hva mangler?
- hva kan brukeren gjøre nå?

Unngå moraliserende eller coachende språk.

## Mikrocopy

Retning:
- norsk bokmål
- konkrete verb
- ingen finanssjargong når enklere språk fungerer
- ingen engelske labels i UI

Eksempel:
- bruk `Legg til utgift`
- unngå `Create transaction`
