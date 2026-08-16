# Teknisk Plan

## Plattform

- iOS
- SwiftUI
- SwiftData
- offline-first
- feature-basert MVVM

## Arkitektur

Appkode ligger i:

- `SporOkonomi/App`
- `SporOkonomi/Domain`
- `SporOkonomi/Features`
- `SporOkonomi/Shared`

Regel:
- View håndterer layout og interaksjon.
- ViewModel håndterer presentasjonslogikk og brukerhandlinger.
- Domain/Services håndterer domenelogikk, import/eksport, auth, demo-data og vedvarende operasjoner.

## Data

SwiftData er primær lagring.

Data skal fungere lokalt uten konto. Konto og backend skal være valgfritt og må ikke være nødvendig for MVP-kjerneflyten.

## Backend

Supabase finnes i repoet for auth og edge functions.

Backend-avhengige funksjoner må:
- feile ryddig når konfigurasjon mangler
- ikke blokkere lokal bruk
- ikke endre App Privacy uten at metadata oppdateres

## Teststrategi

Krev tester ved endringer i:
- beregninger
- dato- og periodehåndtering
- import/eksport
- onboarding
- mål
- challenges
- faste poster
- auth/session

UI-only og dokumentasjonsendringer kan verifiseres manuelt.

## Build-Regel

Bygg prosjektet når endringen påvirker:
- ViewModel
- Service
- SwiftData-modeller
- navigasjon
- nye Swift-typer
- dataflyt mellom lag

Ikke bygg for rene dokumentasjonsendringer.

## Teknisk Gjeld Å Følge Med På

- synlighet og gating av demo/debug/premium/AI-flater
- tydelig feiltilstand for Supabase når backend ikke er konfigurert
- import/eksport-idempotens
- månedsskifte og faste poster
- App Privacy ved endringer i konto eller backend
