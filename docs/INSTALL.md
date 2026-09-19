# Installazione GE360 Prospex Engine

## Requisiti

- Debian/Ubuntu
- Docker
- Docker Compose v2 plugin
- accesso a GitHub per clonare l'upstream Prospex

## Da pacchetto .deb

```bash
sudo apt install ./ge360-prospex-engine_0.1.0_all.deb
sudo ge360-prospex-install
```

La configurazione persistente viene salvata in:

```
/etc/ge360/prospex-engine.env
```

Il sorgente upstream viene installato in:

```
/opt/ge360/prospex-engine/prospex
```

La dashboard predefinita è disponibile su:

```
http://localhost:8788
```

Swagger/API:

```
http://localhost:8788/api/docs
```

## Comandi

```bash
ge360-prospex-status
sudo ge360-prospex-update
sudo ge360-prospex-uninstall
```

Per eliminare anche volumi/configurazione:

```bash
sudo ge360-prospex-uninstall --purge
```

## AI

Prospex può usare provider OpenAI-compatible. Modificare:

```
/etc/ge360/prospex-engine.env
```

Esempio Ollama:

```env
OPENAI_API_KEY=ollama
OPENAI_BASE_URL=http://host.docker.internal:11434/v1
OPENAI_MODEL=qwen2.5:7b
```

Dopo la modifica:

```bash
sudo ge360-prospex-update
```
