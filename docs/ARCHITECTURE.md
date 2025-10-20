# Architecture du Projet d'Analyse de Texte en Racket

Ce document décrit l'architecture logique, les modules et les choix de conception du projet.

## 1. Vue d'ensemble

Le projet est conçu selon les principes de la **décomposition fonctionnelle**. Chaque module a une responsabilité unique et bien définie, ce qui favorise la réutilisabilité, la testabilité et la clarté du code.

L'architecture est organisée en couches, allant des fonctions les plus fondamentales aux fonctionnalités de plus haut niveau.

## 2. Diagramme des Dépendances des Modules

La structure des dépendances est linéaire et simple, ce qui évite les dépendances circulaires et facilite la maintenance.

-   **`main.rkt` (Point d'entrée)** : Dépend de tous les autres modules pour orchestrer la démonstration et l'analyse via la ligne de commande.
-   **`analyzer.rkt` (Logique d'analyse)** : Contient la logique métier pour l'analyse de texte. Il dépend de `core-list.rkt` pour les opérations de base sur les listes.
-   **`library.rkt` (Logique bibliothèque)** : Contient la logique métier pour la gestion de la bibliothèque. Il est autonome mais est utilisé par `main.rkt`.
-   **`core-list.rkt` (Primitives)** : Le module de base, il ne dépend d'aucun autre module. Il fournit des fonctions pures et réutilisables pour la manipulation de listes.

## 3. Description des Modules

### `core-list.rkt`
-   **Responsabilité** : Fournir des implémentations pures et efficaces de fonctions de base pour la manipulation de listes.
-   **Contraintes** : Toutes les fonctions doivent être implémentées avec la **récursivité terminale** et des **accumulateurs**.

### `analyzer.rkt`
-   **Responsabilité** : Contenir toute la logique d'analyse de texte.
-   **Choix de conception (Performance)** : L'implémentation est optimisée en **O(n)** grâce à une construction de table de fréquences en une seule passe.

### `library.rkt`
-   **Responsabilité** : Gérer la structure de données des livres et fournir des fonctions pour interroger la collection.
-   **Démonstration Pédagogique** : Démontre l'utilisation de `filter` avec des prédicats.

### `main.rkt`
-   **Responsabilité** : Servir de point d'entrée et d'interface utilisateur via la ligne de commande.

## 4. Environnement d'Exécution : Docker

-   **Objectif** : Garantir la **reproductibilité**.
-   **Choix de l'image** : Une image Docker personnalisée basée sur `debian:bookworm-slim` est utilisée pour garantir une exécution ARM64 native et stable.

## 5. Tests

-   Un fichier `tests.rkt` séparé utilise le framework `rackunit`.
-   Les tests sont exécutés via `make test` dans l'environnement Docker.