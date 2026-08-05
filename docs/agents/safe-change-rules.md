# Safe Change Rules

Codex skal gjøre trygge, avgrensede endringer.

## Endringsomfang

- Endre kun filer som er nødvendige for oppgaven.
- Ikke gjør opportunistisk refaktorering uten eksplisitt beskjed.
- Ikke rydd i urelatert kode i samme endring.
- Ikke endre navn på typer, filer eller mapper uten tydelig grunn.

## Filer Utenfor Scope

Ikke endre filer utenfor oppgavens scope med mindre:
1. endringen er nødvendig for at løsningen skal bygge eller fungere
2. årsaken forklares eksplisitt i endringsloggen

Hvis en fil utenfor scope må endres:
- forklar hvorfor
- hold endringen minimal
- oppgi den eksplisitt i leveransen

## Beskytt Eksisterende Oppførsel

- Bevar eksisterende oppførsel med mindre oppgaven eksplisitt ber om endring.
- Ikke endre business rules, standardverdier eller formattering uten grunn.
- Ikke fjern edge case-håndtering uten å bevise at den er feil eller overflødig.

## UI-Sikkerhet

- Ikke gjør store layoutendringer når oppgaven gjelder liten copy- eller logikkjustering.
- Ikke bytt komponenttype, navigasjonsmønster eller hierarki uten eksplisitt behov.
- Behold eksisterende visuell stil, spacing og komponentbruk så langt det er mulig.

## Modell- Og Datalagsikkerhet

- Ikke endre SwiftData-modeller, schema eller persistenslogikk uten eksplisitt behov.
- Ved modellendringer: forklar migrasjonskonsekvenser.
- Ikke introduser risiko for duplikater, ikke-idempotent oppførsel eller datatap.

## Testsikkerhet

- Ikke endre eksisterende tester kun for å få grønt.
- Hvis en test må endres, forklar hvorfor testen var feil eller utdatert.
- Nye tester skal beskrive faktisk ønsket oppførsel, ikke implementasjonsdetaljer.

## Refaktoreringssikkerhet

Refaktorering er kun tillatt når:
- den er direkte nødvendig for oppgaven
- den reduserer kompleksitet i berørt område
- den ikke utvider scope unødvendig

Ved refaktorering:
- hold samme oppførsel
- unngå store flyttinger av kode
- del opp i små steg hvis mulig

## Stopp-Regler

Stopp og be om avklaring hvis:
- oppgaven krever store endringer i arkitektur
- flere mulige tolkninger gir ulik produktoppførsel
- endringen påvirker modeller, migrasjoner eller kritisk dataflyt
- løsningen krever endringer i mange filer uten klart scope
