# Rapport Final : Analyseur de Texte et Bibliothèque en Racket

**Auteur:** MAMADOU YALY ET PAPE MATATAR réflection collectif du developpement 11 jours
**INE**: N03732320201
**Email**: mamadou.yaly@nchk.edu.sn
**Cours**: PROGRAMMATION FONCTIONNELLE
**Projet:** SYSTEME DE GESTION DE BIBLIOTHEQUE AVEC UN MINI-ANALYSEUR DE TEXTE EN SCHEME

## 1. Fonctions Réalisées

Le projet est structuré en trois modules principaux, fournissant un ensemble complet de fonctionnalités pour l'analyse de texte et la gestion de bibliothèque.

### Module `core-list.rkt` (Primitives de Listes)

| Fonction             | Signature                               | Description                                         |
| -------------------- | --------------------------------------- | --------------------------------------------------- |
| `number-of-elements` | `(lst) -> integer?`                     | Compte le nombre d'éléments dans une liste.         |
| `my-reverse`         | `(lst) -> list?`                        | Inverse l'ordre des éléments d'une liste.           |
| `member`             | `(element lst) -> boolean?`             | Vérifie si un élément est présent dans une liste.   |
| `occur`              | `(element lst) -> integer?`             | Compte les occurrences d'un élément dans une liste. |

### Module `analyzer.rkt` (Analyse de Texte)

| Fonction        | Signature                                     | Description                                                    |
| --------------- | --------------------------------------------- | -------------------------------------------------------------- |
| `frequence`     | `(lst) -> (listof (cons string? integer?))`   | Calcule la fréquence de chaque mot.                            |
| `unique`        | `(lst) -> (listof string?)`                   | Retourne la liste des mots uniques.                            |
| `doublons`      | `(lst) -> (listof string?)`                   | Extrait les mots qui apparaissent plus d'une fois.             |
| `plus-frequent` | `(lst) -> (cons string? integer?) or '()`     | Trouve la première paire (mot . compte) la plus fréquente.     |

### Module `library.rkt` (Bibliothèque Numérique)

| Fonction              | Signature                                   | Description                                                     |
| --------------------- | ------------------------------------------- | --------------------------------------------------------------- |
| `livre`               | `(titre auteur dispo) -> livre?`            | Construit une structure de livre.                               |
| `auteur=?`            | `(livre nom-auteur) -> boolean?`            | Prédicat qui vérifie si un livre est d'un auteur donné.         |
| `disponible?`         | `(livre) -> boolean?`                       | Prédicat qui vérifie si un livre est disponible.                |
| `livres-par-auteur`   | `(biblio nom-auteur) -> (listof livre?)`    | Filtre les livres d'un auteur spécifique (via `filter`).        |
| `livres-disponibles`  | `(biblio) -> (listof livre?)`               | Filtre les livres disponibles (via `filter`).                   |
| `afficher-livre`      | `(livre) -> void?`                          | Affiche les informations d'un livre de manière formatée.        |
| `afficher-liste-livres`| `(listof livre?) -> void?`                 | Affiche une liste de livres.                                    |


## 2. Difficultés Rencontrées et Solutions Apportées

### a. Problème d'Émulation Docker sur Apple Silicon (ARM64)
-   **Difficulté :** L'image Docker officielle `racket/racket` provoquait une erreur fatale au démarrage du runtime Racket sur les Mac M1/M2.
-   **Solution :** Une **image Docker personnalisée** basée sur `debian:bookworm-slim` (ARM64 natif) a été créée, garantissant un environnement d'exécution stable et reproductible.

### b. Gestion de l'Entrée Utilisateur
-   **Difficulté :** Un mode interactif avec `(read-line)` échouait dans les environnements non-TTY.
-   **Solution :** Le mode interactif a été remplacé par une interface en **ligne de commande** robuste, acceptant le texte via un argument.

### c. Optimisation des Performances
-   **Difficulté :** La première implémentation de l'analyseur avait une complexité de O(n²), inefficace pour de grands textes.
-   **Solution :** Le module a été refactorisé pour utiliser une approche en **une seule passe** (O(n)), rendant les calculs quasi-instantanés.


## 3. Stratégie de Tests et Validation

-   Une suite de **38 tests unitaires** a été implémentée avec `rackunit`, couvrant les cas nominaux, les cas limites et les invariants logiques.
-   Les tests sont exécutés via `make test` dans l'environnement Docker pour garantir leur fiabilité.


## 4. Lien OneCompiler

-   **Lien Gitub pour voir le projet complet et en detail**: https://github.com/zlorgoncho1/ppf-unchk-m1
-   **Lien One Compiler:** https://onecompiler.com/racket/4427v4svw
