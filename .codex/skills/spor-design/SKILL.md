---
name: spor-design
description: Bruk denne skillen for UX, skjermstruktur, UI-konsistens, mikrocopy, tomtilstander og visuelle forbedringer i Spor økonomi.
---

# Spor Design

## Før Designendring

1. Les `AGENTS.md`.
2. Les `docs/agents/product.md`.
3. Definer mål, brukerflyt, edge cases, tomtilstander og mikrocopy.
4. Lås akseptansekriterier før kode når produktoppførsel endres.

## Produktretning

Spor økonomi skal være enkel, rolig, tydelig og rask. Prioriter klar oversikt, enkel registrering og lav kognitiv belastning.

Unngå:
- overfylte skjermer
- duplisert informasjon
- moraliserende språk
- nye kortstiler uten funksjonell grunn

## UI-Regler

- All UI-copy skal være norsk.
- Hver hovedskjerm skal ha maks en tydelig primær CTA.
- Hovedskjermer med tydelig hovedtall eller hovedstatus skal ha hero-kort.
- Seksjonsheadere skal bruke mønsteret tittel til venstre og eventuell sekundær handling til høyre.
- Tomtilstander skal være korte: hva mangler, og hva kan brukeren gjøre nå.
- Budsjett, Investeringer og Mål skal føles som samme produktfamilie uten å bli identiske.

## Verifikasjon

For UI-endringer, vurder:
- light mode
- dark mode
- tomtilstand
- 0-data
- accessibility-labels der handlinger eller innhold endres
- norsk dato- og beløpsformat

Ikke bygg Xcode-prosjektet for rene copy- eller lavrisiko layoutendringer med mindre compile-risikoen tilsier det.
