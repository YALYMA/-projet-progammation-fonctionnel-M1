# Stratégie de Tests

Ce document décrit l'approche de test utilisée pour garantir la qualité et la robustesse du projet.

## 1. Vue d'ensemble

Une suite de **tests unitaires automatisés** a été implémentée pour valider chaque fonction de manière isolée.

-   **Framework utilisé :** `rackunit`
-   **Fichier de tests :** `tests.rkt`
-   **Exécution :** `make test` (via Docker)

## 2. Organisation des Tests

Les tests sont organisés en suites (`test-suite`) qui correspondent à la structure modulaire du projet :
-   `core-list-tests`
-   `analyzer-tests`
-   `library-tests`

## 3. Couverture des Cas de Test

La suite de **38 tests** couvre un large éventail de scénarios :

### a. Cas Nominaux
-   Vérification du comportement attendu avec des entrées standards.

### b. Cas Limites (Edge Cases)
-   **Listes vides (`'()`) :** Chaque fonction est testée avec une liste vide.
-   **Listes à un seul élément.**

### c. Cas Spécifiques et Invariants Logiques
-   **Mots absents.**
-   **Égalités (Ex æquo)** pour `plus-frequent`.
-   **Invariant Logique :** Un test critique vérifie que la somme des fréquences est toujours égale au nombre total de mots.
-   **Idempotence :** Vérification de la double inversion avec `my-reverse`.