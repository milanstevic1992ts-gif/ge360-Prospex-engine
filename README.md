# GE360 Prospex Engine

Wrapper leggero per usare **Prospex** come motore di lead generation dentro GE360, senza riscriverlo.

## Principio

Prospex resta il progetto upstream principale. Questa repository contiene solo ciò che serve a GE360 per:

- installare Prospex;
- fissare una versione upstream verificata;
- applicare piccole patch di compatibilità GE360;
- configurare l'ambiente;
- avviare/fermare/aggiornare il motore;
- preparare in seguito il pacchetto Debian `.deb`;
- collegare Prospex a GE360 Core tramite REST API.

## Upstream

- Progetto: Prospex
- Repository: https://github.com/asiifdev/business-leads-ai-automation
- Licenza: MIT
- Commit iniziale verificato: `5b3e260d3291a201c61240387cbcfd84979476c1`

Il codice Prospex non viene duplicato in questa repository. Lo script di installazione clona l'upstream e applica solo gli adattamenti GE360.

## Architettura

```
GE360 Core
    |
    | REST API
    v
GE360 Prospex Engine
    |
    +-- Prospex upstream
    |   +-- Next.js
    |   +-- NestJS API
    |   +-- PostgreSQL
    |   +-- Redis
    |   +-- scraper / AI
    |
    +-- configurazione GE360
    +-- update / doctor / backup
```

## Stato

### Fase 1
- [x] Repository dedicata
- [x] Strategia upstream senza fork pesante
- [x] Versione upstream bloccata
- [ ] Installer Linux
- [ ] Configurazione persistente
- [ ] Patch runtime GE360
- [ ] Doctor / status
- [ ] Update controllato

### Fase 2
- [ ] Adapter GE360 Core
- [ ] Mapping lead / campaign
- [ ] Webhook / sync
- [ ] Backup / restore

### Fase 3
- [ ] Packaging Debian
- [ ] systemd
- [ ] GitHub Actions per build `.deb`
- [ ] Release installabile

## Licenza

Il wrapper GE360 è separato dal progetto upstream. Prospex è distribuito con licenza MIT; vedere `THIRD_PARTY_NOTICES.md`.
