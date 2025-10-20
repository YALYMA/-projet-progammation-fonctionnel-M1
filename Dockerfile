# Dockerfile pour le projet Racket de programmation fonctionnelle
# Utiliser une image de base Debian nativement compatible ARM64
FROM debian:bookworm-slim

# Installer Racket via le gestionnaire de paquets
RUN apt-get update && apt-get install -y --no-install-recommends racket && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /app

# Copier le code dans l'image (pour l'exécution)
COPY . .

# Commande par défaut pour exécuter le programme principal
CMD ["racket", "main.rkt"]
