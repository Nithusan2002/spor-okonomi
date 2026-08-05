# Produkt Og UI

## Produktmål

Spor økonomi skal være:
- en enkel og rolig budsjettapp
- mindre kompleks enn tradisjonelle budsjettverktøy
- fokusert på oversikt fremfor detaljer
- offline-first og rask

Prioriteter:
1. Klarhet
2. Få steg for å registrere transaksjoner
3. Tydelig økonomisk oversikt
4. Lav kognitiv belastning

Unngå:
- unødvendig kompleksitet
- overfylte skjermer
- duplisert informasjon

## Produktposisjonering

Spor økonomi er en enkel budsjettapp for folk som vil forstå økonomien sin uten kompliserte systemer.

Appen skal oppleves som:
- enkel
- rolig
- tydelig
- rask å bruke

Den konkurrerer ikke på flest funksjoner, men på:
- klar oversikt
- enkel registrering
- lav kognitiv belastning

## UI Consistency System

Mål:
- gjøre appen mer symmetrisk uten å gjøre skjermene monotone
- sikre at Budsjett, Investeringer og Mål føles som samme produktfamilie
- standardisere mønstre for hero, seksjoner, forms og handlinger

Prinsipp:
- del visuell logikk og komponentmønstre
- varier informasjonsprioritet per feature
- standardiser struktur før dekor

## Hero-Regel

Alle hovedskjermer skal ha et hero-kort øverst når skjermen har ett tydelig hovedtall eller hovedstatus.

Hero-kortet skal som standard ha:
- liten label
- ett hovedtall eller hovedstatus
- en sekundær statuslinje
- eventuelt en lavprioritert metadata-linje

Hero-kort skal dele samme visuelle shell:
- lik hjørneradius
- lik intern padding
- subtil gradient
- myk shadow
- samme border/stroke-logikk

Innholdet skal fortsatt være feature-spesifikt:
- Budsjett skal være mer operativt og handlingsnært
- Investeringer skal være mer status- og utviklingsdrevet
- Mål skal være mer fokusert og enkelt

## Seksjonsheader-Regel

Alle større seksjoner skal bruke samme grunnmønster:
- venstre: seksjonstittel
- høyre: en sekundær handling hvis relevant

Eksempler:
- `Beholdning` + `+`
- `Grupper` + `Rediger`
- `Historikk` + `Se alle`

Regler:
- seksjonsspesifikke handlinger skal ligge i header når de naturlig hører til seksjonen
- unngå lokale admin-handlinger nederst hvis de kan ligge i header
- høyrehandlingen skal være liten, tydelig og sekundær

## Primær CTA-Regel

Hver hovedskjerm skal ha maks en tydelig primær CTA.

Regler:
- bruk floating CTA kun når handlingen er sentral for skjermen
- copy skal alltid være feature-spesifikk
- basestil kan være delt, men tekst og accessibility-label skal ikke hardkodes til en annen feature
- primær CTA skal ikke konkurrere med lokale seksjonshandlinger

## Form-Regel

Alle opprett- og rediger-skjermer skal bruke samme grunnstruktur:
- tydelig skjermtittel
- kort hjelpetekst kun ved behov
- labels over felter
- jevn vertikal spacing
- en tydelig lagrehandling

Unngå:
- dobbeltoverskrifter som sier nesten det samme
- felt uten tydelig label
- blanding av ulike datovisninger eller inputmønstre i samme form

## Kort-Regel

Kort skal brukes for å gruppere informasjon, ikke bare som dekor.

Kort skal være konsistente på tvers av appen:
- samme radiusfamilie
- samme border-logikk
- samme shadow-nivå per korttype
- samme padding-prinsipper

Ikke introduser nye kortstiler uten tydelig funksjonell grunn.

## Typografi-Regel

Det skal være tydelig hva som er viktigst på skjermen.

Regler:
- ett hovedtall per skjerm får sterkest visuell vekt
- seksjonstitler skal bruke konsistent størrelse og vekt
- metadata og hjelpetekst skal bruke sekundært nivå
- ikke la flere elementer konkurrere om å være hovedfokus

## Tomtilstandsregel

Alle tomtilstander skal være korte og konkrete:
- hva mangler
- hva kan brukeren gjøre nå

Regler:
- en anbefalt handling er nok
- ikke bruk flere coach-kort samtidig
- unngå moraliserende språk

## Handlingshierarki-Regel

Handlingshierarki skal være tydelig:
- primær handling: visuelt tydelig og unik
- sekundære handlinger: små og lokale
- administrative handlinger: nedtonet eller flyttet til riktig seksjonsnivå
- destruktive handlinger: vises bare når konteksten er tydelig

## Språk- Og Formatregel

All UI-copy skal være norsk.

Regler:
- bruk norsk datoformat konsekvent
- bruk konsekvent pengebeløp-format
- unngå blanding av norsk og engelsk i labels, datoer og hjelpetekst

## Feature-Familie-Regel

Budsjett, Investeringer og Mål skal føles som samme app.

Det betyr:
- samme designlogikk
- samme komponentfamilie
- samme handlingshierarki
- ulik informasjonsprioritet per feature

Målet er ikke identiske skjermer, men gjenkjennelig struktur og rytme.

Prioriter standardisering i denne rekkefølgen:
1. hero-kort
2. seksjonsheadere
3. primær CTA
4. formskjermer
5. tomtilstander
