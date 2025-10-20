# Documentation de l'API

Ce document fournit une référence complète pour toutes les fonctions publiques disponibles dans les modules du projet.

## 1. Module `core-list.rkt`

### `(number-of-elements lst)`
-   **Signature:** `(lst) -> integer?`
-   **Description:** Compte le nombre d'éléments dans une liste.

### `(my-reverse lst)`
-   **Signature:** `(lst) -> list?`
-   **Description:** Inverse l'ordre des éléments d'une liste sans la modifier.

### `(member element lst)`
-   **Signature:** `(element lst) -> boolean?`
-   **Description:** Vérifie si un élément est présent dans une liste.

### `(occur element lst)`
-   **Signature:** `(element lst) -> integer?`
-   **Description:** Compte le nombre d'occurrences d'un élément.

## 2. Module `analyzer.rkt`

### `(frequence lst)`
-   **Signature:** `(lst) -> (listof (cons string? integer?))`
-   **Description:** Calcule la fréquence de chaque mot.

### `(unique lst)`
-   **Signature:** `(lst) -> (listof string?)`
-   **Description:** Retourne la liste des mots uniques.

### `(doublons lst)`
-   **Signature:** `(lst) -> (listof string?)`
-   **Description:** Extrait les mots qui apparaissent plus d'une fois.

### `(plus-frequent lst)`
-   **Signature:** `(lst) -> (cons string? integer?) or '()`
-   **Description:** Trouve la première paire `(mot . compte)` la plus fréquente.

## 3. Module `library.rkt`

### `(livre titre auteur dispo)`
-   **Signature:** `(titre string?, auteur string?, dispo boolean?) -> livre?`
-   **Description:** Construit une structure de livre.

### `(auteur=? livre nom-auteur)`
-   **Signature:** `(livre? nom-auteur string?) -> boolean?`
-   **Description:** Prédicat qui vérifie l'auteur d'un livre.

### `(disponible? livre)`
-   **Signature:** `(livre?) -> boolean?`
-   **Description:** Prédicat qui vérifie si un livre est disponible.

### `(livres-par-auteur biblio nom-auteur)`
-   **Signature:** `(biblio (listof livre?), nom-auteur string?) -> (listof livre?)`
-   **Description:** Filtre les livres d'un auteur spécifique.

### `(livres-disponibles biblio)`
-   **Signature:** `(biblio (listof livre?)) -> (listof livre?)`
-   **Description:** Filtre les livres qui sont disponibles.