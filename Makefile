# Makefile pour le projet Racket de programmation fonctionnelle

# Variables
DOCKER_IMAGE = racket/racket:latest
CUSTOM_IMAGE_NAME = racket-arm64-projet
PROJECT_DIR = $(PWD)
WORK_DIR = /app

# Variable pour le texte, peut être surchargée depuis la ligne de commande
TEXT ?= ""

# Commande par défaut
.DEFAULT_GOAL := help

# Afficher l'aide
help:
	@echo "Commandes disponibles :"
	@echo "  make build  - Construire l'image Docker personnalisée"
	@echo "  make run TEXT=\\\"votre phrase...\\\" - Exécuter l'analyseur avec un texte (via Docker)"
	@echo "  make demo   - Exécuter la démonstration par défaut (via Docker)"
	@echo "  make test   - Exécuter les tests unitaires (via Docker)"
	@echo "  make package- Créer une archive .zip du projet pour la livraison"
	@echo "  make clean  - Nettoyer les fichiers temporaires et les binaires"

# Construire l'image Docker personnalisée
build:
	docker build -t $(CUSTOM_IMAGE_NAME) .

# Exécuter le programme principal avec un texte fourni
run: build
	docker run --rm $(CUSTOM_IMAGE_NAME) racket main.rkt $(TEXT)

# Exécuter la démonstration par défaut
demo: build
	docker run --rm $(CUSTOM_IMAGE_NAME) racket main.rkt

# Exécuter les tests (si le fichier tests.rkt existe)
test: build
	@if [ -f tests.rkt ]; then \
		docker run --rm $(CUSTOM_IMAGE_NAME) racket tests.rkt; \
	else \
		echo "Aucun fichier tests.rkt trouvé. Créez-le pour exécuter des tests."; \
	fi

# Nettoyer les fichiers temporaires
clean:
	@echo "Nettoyage des fichiers temporaires..."
	@find . -name "*~" -type f -delete 2>/dev/null || true
	@find . -name "*.bak" -type f -delete 2>/dev/null || true
	@rm -f analyseur-texte
	@echo "Nettoyage terminé."

# Créer une archive du projet
package:
	@echo "Création de l'archive racket-analyseur-v1.0.zip..."
	@zip -r racket-analyseur-v1.0.zip . -x "*.git*" "*__pycache__*" "*.DS_Store*" ".*"
	@echo "Archive créée."

# Indiquer que ces cibles ne correspondent pas à des fichiers
.PHONY: help build run demo repl test clean native package
