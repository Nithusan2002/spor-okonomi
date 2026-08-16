# Release-Readiness

Denne filen er en samlesjekk før intern TestFlight og App Store-innsending.

Se også:
- `INTERNAL_TESTING.md`
- `AppStoreConnect-metadata.md`
- `docs/legal/personvern-no.md`
- `docs/legal/vilkar-no.md`

## Status

Nåværende fase: intern release-klargjøring.

## Før Intern TestFlight

- [ ] Xcode-build er grønn
- [ ] enhetstester er kjørt
- [ ] onboarding er testet
- [ ] lokal bruk uten konto er testet
- [ ] kontoflyt er testet eller bevisst utelatt fra denne builden
- [ ] første transaksjon er testet
- [ ] Oversikt er testet med 0-data og realistiske data
- [ ] Budsjett er testet med inntekt, utgift og sparing
- [ ] Investeringer er testet med minst ett snapshot
- [ ] eksport/import er testet
- [ ] varsler er testet hvis de er synlige i builden
- [ ] Face ID er testet hvis det er synlig i builden
- [ ] debug- og demo-verktøy er ikke synlige for vanlige brukere

## Før App Store-Innsending

- [ ] Privacy Policy URL fungerer
- [ ] Support URL fungerer
- [ ] App Privacy i App Store Connect matcher faktisk dataflyt
- [ ] `PrivacyInfo.xcprivacy` er gjennomgått
- [ ] appnavn, undertittel og beskrivelse er oppdatert
- [ ] skjermbilder matcher nåværende UI
- [ ] ingen "kommer snart"-flater ligger i kjerneflyten
- [ ] premium eller AI er enten ferdig, skjult eller tydelig kontrollert
- [ ] testkonto er dokumentert hvis App Review trenger konto
- [ ] kjente begrensninger er vurdert opp mot review-risiko

## Kjente Risikoer

- Konto- og Supabase-flyt påvirker App Privacy-svar.
- Demo- og debugverktøy må ikke lekke til vanlig release-opplevelse.
- Juridiske URL-er må holdes stabile når GitHub Pages eller domene endres.
- AI- og premiumflater bør ikke være delvis synlige hvis de ikke er release-klare.

## Release Notes-Mal

Kort norsk tekst:

```text
Første versjon av Spor økonomi.

Appen hjelper deg å få enkel oversikt over budsjett, sparing, mål og investeringer uten bankintegrasjon.
```
