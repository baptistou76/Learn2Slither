
# ============================================================
# Learn2Slither - Commandes principales du projet
# ============================================================

SHELL := /bin/sh

.PHONY: help check-env build test package clean backend frontend \
        db-up db-down up down logs status reset-db

# ------------------------------------------------------------
# Aide
# ------------------------------------------------------------

help:
	@echo ""
	@echo "Learn2Slither - Commandes disponibles"
	@echo "-------------------------------------"
	@echo "  make help       Affiche cette aide"
	@echo "  make build      Compile et verifie tout le projet"
	@echo "  make test       Lance les tests Maven"
	@echo "  make package    Genere les packages"
	@echo "  make clean      Supprime les fichiers de compilation"
	@echo "  make backend    Lance le backend Spring Boot"
	@echo "  make frontend   Lance le frontend JavaFX"
	@echo ""
	@echo "Docker / PostgreSQL :"
	@echo "  make db-up      Demarre PostgreSQL"
	@echo "  make db-down    Arrete PostgreSQL sans supprimer le conteneur"
	@echo "  make up         Demarre l'infrastructure actuelle"
	@echo "  make down       Arrete et supprime les conteneurs"
	@echo "  make logs       Affiche les logs PostgreSQL"
	@echo "  make status     Affiche l'etat des conteneurs"
	@echo "  make reset-db   Supprime les conteneurs et les donnees PostgreSQL"
	@echo ""

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

check-env:
	@test -f .env || { echo "Erreur : fichier .env absent."; echo "Execute : cp .env.example .env"; exit 1; }

# ------------------------------------------------------------
# Maven
# ------------------------------------------------------------

build:
	mvn clean verify

test:
	mvn test

package:
	mvn package

clean:
	mvn clean

# ------------------------------------------------------------
# Applications
# ------------------------------------------------------------

backend: check-env
	@set -a && . ./.env && set +a && mvn -pl backend spring-boot:run

frontend:
	mvn -pl frontend javafx:run

# ------------------------------------------------------------
# Docker / PostgreSQL
# ------------------------------------------------------------

db-up: check-env
	docker compose up -d database

db-down:
	docker compose stop database

# Pour le moment, l'infrastructure se limite a PostgreSQL.
# Nous ajouterons le backend Dockerise plus tard.
up: db-up

down:
	docker compose down

logs:
	docker compose logs -f database

status:
	docker compose ps

# ATTENTION : cette commande supprime definitivement les donnees
# stockees dans le volume PostgreSQL.
reset-db:
	@printf "ATTENTION : toutes les donnees PostgreSQL seront supprimees.\n"
	@printf "Confirmer ? (oui/non) : "
	@read answer; \
	if [ "$$answer" = "oui" ]; then \
		docker compose down -v; \
		echo "Base de donnees reinitialisee."; \
	else \
		echo "Operation annulee."; \
	fi
