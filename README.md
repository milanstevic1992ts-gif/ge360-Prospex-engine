# GE360 Prospex Engine

Wrapper leggero per usare **Prospex** come motore di lead generation dentro GE360, senza riscriverlo.

## Principio

Prospex resta il progetto upstream principale. Questa repository contiene solo ciò che serve a GE360 per:

- installare Prospex;
- fissare una versione upstream verificata;
- applicare piccole patch di compatibilità GE360;
- configurare l'ambiente;
- avviare, controllare e aggiornare il motore;
- produrre un pacchetto Debian `.deb` leggero;
- collegare in seguito Prospex a GE360 Core tramite REST API.

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
    +-- update / status / packaging
```

## Installazione prevista

Dopo aver scaricato l'artefatto `.deb` prodotto da GitHub Actions:

```bash
sudo apt install ./ge360-prospex-engine_0.1.0_all.deb
sudo ge360-prospex-install
```

Comandi principali:

```bash
ge360-prospex-status
sudo ge360-prospex-update
sudo ge360-prospex-uninstall
```

Dashboard predefinita:

```text
http://localhost:8788
```

API / Swagger:

```text
http://localhost:8788/api/docs
```

## Stato

### Fase 1
- [x] Repository dedicata
- [x] Strategia upstream senza fork pesante
- [x] Versione upstream bloccata
- [x] Installer Linux
- [x] Configurazione persistente
- [x] Patch runtime GE360
- [x] Status / health check
- [x] Update controllato
- [x] Migrazioni database automatiche

### Fase 2
- [ ] Adapter GE360 Core
- [ ] Mapping lead / campaign
- [ ] Webhook / sync
- [ ] Backup / restore

### Fase 3
- [x] Packaging Debian
- [ ] systemd dedicato
- [x] GitHub Actions per build `.deb`
- [ ] Release installabile verificata su Debian

## Licenza

Il wrapper GE360 è separato dal progetto upstream. Prospex è distribuito con licenza MIT; vedere `THIRD_PARTY_NOTICES.md`.
