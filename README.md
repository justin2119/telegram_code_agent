---
title: Telegram Code Agent
emoji: 🤖
colorFrom: blue
colorTo: indigo
sdk: docker
license: mit
---

# 🤖 Telegram Code Agent — C'est carré !

Wesh mon reuf, bienvenue sur le **Telegram Code Agent**. Un bot Telegram codé en **Dart** qui suit les principes **Clean Architecture** (data, domain, presentation), intègre **Teledart** pour la communication Telegram et un **client LLM** pour générer des réponses IA.

## 🚀 Features

- **Clean Architecture** : séparation claire du code en `domain`, `data` et `presentation`.
- **Teledart** : écoute les commandes `/start` et `/ask <question>`.
- **LLM client** : wrapper simple (HTTP) pour appeler n'importe quel LLM (ex : OpenAI, anthropic, etc.).
- **Docker** : build et run en un clin d'œil, prêt pour Fly.io, Render, Koyeb, etc.
- **Variables d'environnement** : `TELEGRAM_BOT_TOKEN` & `LLM_API_KEY`.

## 📦 Installation locale

1. **Clone le repo**
   ```bash
   git clone https://github.com/justin2119/telegram_code_agent.git
   cd telegram_code_agent
   ```
2. **Installe les dépendances**
   ```bash
   dart pub get
   ```
3. **Crée un `.env`** à la racine
   ```env
   TELEGRAM_BOT_TOKEN=ton_token_telegram
   LLM_API_KEY=ta_clef_llm
   ```
4. **Lance le bot**
   ```bash
   dart run lib/presentation/main.dart
   ```

## 🐳 Déploiement Docker

Un `Dockerfile` est fourni. Build & run :
```bash
docker build -t telegram-code-agent .
docker run -d -p 7860:7860 --env-file .env telegram-code-agent
```
Le container expose le port **7860** (health‑check pour les platforms comme Fly.io).

## 🌐 Déploiement sur Fly.io / Render / Koyeb

Utilise le `Dockerfile` et configure les variables d’environnement via le dashboard de ton provider.

## 🛠️ Structure du projet

```
lib/
 ├─ data/          # Implémentations concrètes (LLM client, repos)
 ├─ domain/        # Entités, abstractions, interfaces
 └─ presentation/  # Entrée du bot (Teledart)
```

## 📜 Licence

MIT – Feel free to fork, remix, and pimp it.

C'est carré, bon codage mon reuf ! ✌️
