# Datamodell

Dette er en konseptuell oversikt. Faktiske SwiftData-modeller ligger i `SporOkonomi/Domain/Models/DomainModels.swift`.

## Hovedområder

### Budsjett

Representerer månedlig økonomi:
- inntekt
- utgifter
- manuell sparing
- gruppegrenser
- transaksjoner
- faste poster

Kritiske regler:
- måned og periode må håndteres konsekvent
- faste poster må kunne opprettes idempotent
- 0-data skal gi forståelig tomtilstand

### Oversikt

Presenterer samlet status:
- netto denne måneden
- spart hittil i år
- målstatus
- relevante budsjett- og investeringssummer

Oversikt skal være en presentasjonsflate, ikke et sted for ny forretningslogikk.

### Investeringer

Representerer manuelle investeringssnapshots:
- beholdning
- kategori eller type
- måned/periode
- historisk utvikling

MVP skal ikke love sanntidskurser eller automatisk meglerintegrasjon.

### Mål Og Challenges

Representerer brukerens spareintensjon og enkle utfordringer:
- målbeløp
- progresjon
- status
- periode eller varighet der det er relevant

Endringer her må testes fordi små beregningsfeil lett påvirker brukerens hovedopplevelse.

### Innstillinger Og Preferanser

Representerer:
- visningsvalg
- sikkerhet
- konto/session-info
- eksport/import
- personvernrelaterte valg

Kontoopplysninger påvirker App Store Privacy-metadata.

## Persistensprinsipper

- Offline-first er standard.
- Brukeren skal kunne bruke appen uten bankintegrasjon.
- Import må ikke skape duplikater.
- Eksport må være lesbar nok til at brukeren forstår hva som flyttes.
- Modellendringer krever eksplisitt migrasjonsvurdering.

## Ikke Del Av MVP-Datamodellen

- bankkontoer fra ekstern bankintegrasjon
- automatisk transaksjonsfeed
- flerbrukerroller
- sanntidspriser for investeringer
- regnskapsbilag eller kvitteringer
