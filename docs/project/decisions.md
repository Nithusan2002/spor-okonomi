# Beslutninger

Denne filen samler produkt- og teknologibeslutninger som bør være stabile over tid.

## 2026-08-16: Dokumentstruktur For Prosjektstyring

Beslutning:
- prosjektstyringsdokumenter legges i `docs/project/`
- agentinstrukser blir liggende i `AGENTS.md` og `docs/agents/`
- juridiske tekster blir liggende i `docs/legal/`

Begrunnelse:
- skiller prosjektretning fra agentarbeidsflyt og publiserte juridiske sider
- gjør det enklere å finne roadmap, release og produktstatus

## MVP: Ingen Bankintegrasjon

Beslutning:
- bankintegrasjon er ikke del av MVP

Begrunnelse:
- reduserer teknisk og juridisk risiko
- holder produktet fokusert på enkel manuell oversikt
- passer offline-first-retningen

## MVP: Offline-First

Beslutning:
- appen skal fungere lokalt uten konto

Begrunnelse:
- senker terskelen for onboarding
- gjør produktløftet tydeligere
- begrenser avhengighet til backend i første versjon

## Produkt: Norsk UI

Beslutning:
- all synlig UI-copy skal være norsk

Begrunnelse:
- appen er posisjonert for norsk personlig økonomi
- norsk språk gjør budsjettflyten roligere og mer konkret for målgruppen

## Release: Hold Scope Stabilt Før Første Innsending

Beslutning:
- før første App Store-innsending prioriteres stabilisering over nye funksjoner

Begrunnelse:
- prosjektet har allerede nok MVP-flater
- risikoen ligger nå mer i kvalitet, personvern, gating og førsteinntrykk enn i funksjonsmangel
