---
name: spor-okonomilogikk
description: Endre og verifiser budsjettberegninger, sparing, mål, investeringer, faste poster og måned-/datoregler i Spor økonomi.
---

# Økonomilogikk

Start i berørt feature og `SporOkonomi/Domain/Services/FinanceServices.swift`. Les eksisterende tester for området før du endrer semantikk.

Bevar skillet mellom inntekt, utgift, refusjon, overføring og manuell sparing. `budgetImpact` og `trackedBudgetImpact` har ulik behandling av sparing; ikke slå dem sammen uten avklart produktoppførsel. Kontroller at sparing, innskudd og investeringsverdi ikke telles dobbelt på tvers av Oversikt og Investeringer.

Bruk eksisterende periodKey-/kalenderregler. Test relevante måneds- og årsskifter, februar, dato på grensen, nullverdier og fortegn. Faste poster og snapshots skal tåle gjentatt kjøring uten duplikater. Endret avrunding eller beløpstype krever vurdering av eksisterende data og visning; ikke migrer hele domenet som del av en liten beregningsfix.

Bruk målrettede regresjonstester i `BudgetFeatureTests`, `OverviewFeatureTests`, `InvestmentsFeatureTests`, `SavingsAndChallengeTests` eller `RecurringAndDemoTests` etter området. Ved logikkbug: reproduksjonstest før fix når praktisk. Følg build-policyen i `docs/agents/workflow.md`.
