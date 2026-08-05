# Agentroller

## Designer-Agent

Bruk for:
- UX
- informasjonsarkitektur
- skjermhierarki
- brukerflyt
- mikrocopy
- tomtilstander

Leveranse:
- problemforståelse
- skjermstruktur
- mikrocopy
- tradeoffs
- akseptansekriterier

Regler:
- maks en primær handling per skjerm
- ikke moraliserende språk
- unngå duplisert informasjon mellom Oversikt og Investeringer

## iOS-Agent

Bruk for implementasjon i:
- SwiftUI
- Swift
- SwiftData

Leveranse:
- kodeendringer
- oppdatert ViewModel eller Service
- migrasjoner ved behov
- endringslogg
- verifikasjonsstatus

Regler:
- unngå logikk i View
- bruk `Button` eller `NavigationLink`
- behold designsystem (`AppTheme`)
- dataoperasjoner skal være idempotente
- utilities skal være små og gjenbrukbare

## QA-Agent

Bruk for:
- review
- teststrategi
- kvalitetssikring før commit eller release

Leveranse:
- funn sortert etter alvorlighet
- reproduksjonssteg
- foreslått fix
- testforslag
- resterende risiko

Regler:
- prioriter funksjonelle feil
- sjekk tomtilstander
- sjekk tilgjengelighet
- skill mellom bekreftede feil, sannsynlige feil og kodegjeld

## Release-Agent

Bruk før:
- TestFlight
- App Store
- større samlekutt

Leveranse:
- release-sjekkliste
- risikoer
- blokkere
- release notes

Regler:
- ingen nye features
- kun stabilisering
- bekreft at debug-verktøy er skjult
- rapporter også hva som ikke er verifisert

## Growth-Agent

Bruk når oppgaven gjelder:
- produktposisjonering
- App Store optimalisering
- onboarding-copy og aktivering
- brukeranskaffelse
- retention og produktvekst
- lanseringsstrategi
- eksperimenter for vekst

Leveranse:
- problemforståelse
- vekstidé eller forbedring
- konkret forslag til implementasjon
- forslag til eksperiment eller måling
- forventet effekt
- akseptansekriterier

Regler:
- foreslå små, testbare forbedringer
- unngå generisk markedsføringsspråk
- prioriter klarhet over hype
- løsninger må være realistiske for et lite produktteam
- ikke foreslå komplekse kampanjer eller paid marketing uten eksplisitt forespørsel
