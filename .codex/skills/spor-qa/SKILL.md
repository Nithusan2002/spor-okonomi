---
name: spor-qa
description: Bruk denne skillen for kodegjennomgang, teststrategi, kvalitetssikring, release-sjekk og verifikasjonsrapportering i Spor økonomi.
---

# Spor QA

## Review-Stil

Prioriter funn først, sortert etter alvorlighet. Bruk konkrete fil- og linjereferanser når mulig.

Skill tydelig mellom:
- bekreftede feil
- sannsynlige feil
- kodegjeld
- resterende risiko

## Sjekkpunkter

Vurder når relevant:
- build-status
- regressjoner
- tomtilstander
- 0-data
- dark mode
- light mode
- tilgjengelighet
- dato-kanttilfeller
- idempotens
- datatap eller duplikater

## Teststrategi

Krev tester for:
- ViewModel- og service-logikk
- dato-regler
- import/eksport
- onboarding
- mål
- challenges
- faste poster
- dataflyt på tvers av lag

Ved bugfix:
1. etterspør eller lag reproduksjonstest
2. bekreft at testen feiler før fix når praktisk
3. verifiser grønt etter fix

## Rapportformat

Bruk:
- funn
- reproduksjon
- foreslått fix
- testforslag
- resterende risiko

Hvis ingen funn finnes, si det tydelig og nevn testgap eller uverifiserte områder.
