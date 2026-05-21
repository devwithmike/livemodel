# Makefile for LiveModel project

BACKEND_DIR := services/backend
FRONTEND_DIR := services/frontend
VENV := $(BACKEND_DIR)/.venv
DC := docker compose

.PHONY: help install up down build logs ps restart clean dev
.PHONY: frontend-install frontend-dev frontend-build
.PHONY: backend-venv backend-install backend-dev backend-tests

help:
	@echo "Available targets:"
	@echo "  install      Install backend and frontend dependencies"
	@echo "  up               Start services via docker compose"
	@echo "  down             Stop services"
	@echo "  build            Build docker services"
	@echo "  logs             Follow docker logs"
	@echo "  ps               List running docker services"
	@echo "  restart          Restart docker services"
	@echo "  dev              Run both backend and frontend in development mode"
	@echo "  frontend-install Install frontend dependencies"
	@echo "  frontend-dev     Run frontend dev server"
	@echo "  frontend-build   Build frontend"
	@echo "  backend-venv     Create backend virtualenv"
	@echo "  backend-install  Install backend Python dependencies"
	@echo "  backend-dev      Run backend (uvicorn) using .venv"
	@echo "  backend-tests    Run backend tests (if any)"
	@echo "  clean            Remove build artifacts and node_modules/.venv"

install: backend-install frontend-install

# Docker / compose helpers
up:
	$(DC) up --build

down:
	$(DC) down

build:
	$(DC) build --no-cache

logs:
	$(DC) logs -f

ps:
	$(DC) ps

restart: down up

# Frontend targets
frontend-install:
	cd $(FRONTEND_DIR) && npm install

frontend-dev:
	cd $(FRONTEND_DIR) && npm run dev

frontend-build:
	cd $(FRONTEND_DIR) && npm run build

# Backend targets
# Create a virtualenv in $(VENV)

# Create or ensure a virtualenv managed by `uv` (if desired)
backend-venv:
	cd $(BACKEND_DIR) && uv venv

# Install backend dependencies using `uv sync` (reads pyproject/lock if present)
backend-install: backend-venv
	cd $(BACKEND_DIR) && uv sync

backend-dev:
	cd $(BACKEND_DIR) && uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

backend-tests:
	@echo "To run tests with uv:"
	@echo "  cd $(BACKEND_DIR) && uv run pytest"

dev:
	@echo "Starting backend and frontend in development mode..."
	@$(MAKE) -j2 backend-dev frontend-dev

clean:
	-@rm -rf $(VENV)
	-@rm -rf $(FRONTEND_DIR)/node_modules
	-@rm -rf $(FRONTEND_DIR)/dist
	-@echo "Cleaned .venv, node_modules and frontend/dist"
