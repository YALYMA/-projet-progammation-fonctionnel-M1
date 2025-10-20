# Analyseur de Texte et Bibliothèque en Racket

[![Statut des tests](https://img.shields.io/badge/tests-38/38%20succès-brightgreen)](tests.rkt)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Racket Version](https://img.shields.io/badge/Racket-8.7-blueviolet)](https://racket-lang.org/)

Un projet académique robuste démontrant les principes de la programmation fonctionnelle avec Racket. Il inclut un analyseur de texte performant (O(n)) et une mini-bibliothèque numérique, le tout exécutable dans un environnement Docker reproductible.

## 🚀 Fonctionnalités

### Analyseur de Texte
-   **Statistiques Complètes** : Calcule le nombre de mots, les mots uniques, les doublons, la fréquence de chaque mot et le mot le plus fréquent.
-   **Performances Optimisées** : Utilise une approche en une seule passe (O(n)) pour une analyse rapide, même sur de grands textes.
-   **Interface CLI** : Accepte le texte à analyser directement depuis la ligne de commande.

### Bibliothèque Numérique
-   **Gestion de Collection** : Structure de données simple pour gérer une liste de livres.
-   **Filtrage Puissant** : Démontre l'utilisation de fonctions d'ordre supérieur (`filter`) avec des prédicats pour rechercher des livres par auteur ou par disponibilité.
-   **Affichage Formaté** : Fonctions dédiées pour une présentation claire des résultats.

## ⚙️ Architecture

Le projet est divisé en modules clairs avec des responsabilités uniques :
-   `core-list.rkt`: Fonctions pures et récursives terminales pour les listes.
-   `analyzer.rkt`: Logique d'analyse de texte optimisée.
-   `library.rkt`: Gestion de la collection de livres.
-   `main.rkt`: Point d'entrée et interface en ligne de commande.

Pour plus de détails, consultez le document d'architecture complet : [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## 🛠️ Utilisation

### Prérequis
-   [Docker](https://www.docker.com/get-started) installé sur votre système.

### Commandes Principales (`Makefile`)

1.  **Construire l'image Docker** (nécessaire une seule fois) :
    ```bash
    make build
    ```

2.  **Analyser un texte personnalisé** :
    ```bash
    make run TEXT="la programmation fonctionnelle est une approche élégante"
    ```

3.  **Lancer la démonstration par défaut** :
    ```bash
    make demo
    ```

### Commandes de Développement

-   **Lancer les tests unitaires** (38 tests) :
    ```bash
    make test
    ```

### Livraison du Projet

-   **Créer une archive `.zip`** du projet complet :
    ```bash
    make package
    ```

## 🌐 Version en Ligne (OneCompiler)

Pour une démonstration rapide sans Docker, une version unifiée du code est disponible.
-   **Lien OneCompiler :** https://onecompiler.com/racket/4427v4svw
-   **Instructions :** Copiez le contenu de [`main.onecompiler.rkt`](main.onecompiler.rkt) et collez-le dans l'éditeur.
