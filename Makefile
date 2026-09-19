SHELL := /bin/bash

.PHONY: install update status uninstall purge

install:
	sudo bash scripts/install.sh

update:
	sudo bash scripts/update.sh

status:
	bash scripts/status.sh

uninstall:
	sudo bash scripts/uninstall.sh

purge:
	sudo bash scripts/uninstall.sh --purge
