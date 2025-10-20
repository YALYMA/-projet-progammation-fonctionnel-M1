#lang racket

;; Module core-list.rkt
;; Fonctions utilitaires de base pour les listes avec récursivité terminale

(provide number-of-elements
         my-reverse
         member
         occur)

;; -----------------------------------------------------------------------------
;; Compte le nombre d'éléments dans une liste.
;;
;; Signature: (number-of-elements lst) -> integer?
;; @param lst: La liste à compter.
;; @return: Le nombre d'éléments dans la liste.
;;
;; Logique:
;; Utilise une fonction interne `loop` avec un accumulateur `acc`.
;; La récursivité terminale est garantie car l'appel récursif est la dernière
;; opération effectuée, ce qui évite un débordement de pile sur de longues listes.
;;
;; Exemple: (number-of-elements '(a b c)) => 3
;;
(define (number-of-elements lst)
  (define (loop rest acc)
    (if (null? rest)
        acc
        (loop (cdr rest) (+ acc 1))))
  (loop lst 0))

;; -----------------------------------------------------------------------------
;; Inverse l'ordre des éléments d'une liste.
;; Ne mute pas la liste originale.
;;
;; Signature: (my-reverse lst) -> list?
;; @param lst: La liste à inverser.
;; @return: Une nouvelle liste avec les éléments dans l'ordre inverse.
;;
;; Logique:
;; La boucle récursive terminale parcourt la liste et ajoute chaque élément
;; en tête de l'accumulateur `acc` avec `(cons ...)`. Cette méthode est très
;; efficace car `cons` est une opération en temps constant.
;;
;; Exemple: (my-reverse '(a b c)) => '(c b a)
;;
(define (my-reverse lst)
  (define (loop rest acc)
    (if (null? rest)
        acc
        (loop (cdr rest) (cons (car rest) acc))))
  (loop lst '()))

;; -----------------------------------------------------------------------------
;; Vérifie si un élément est présent dans une liste.
;;
;; Signature: (member element lst) -> boolean?
;; @param element: L'élément à rechercher.
;; @param lst: La liste dans laquelle chercher.
;; @return: #t si l'élément est trouvé, sinon #f.
;;
;; Logique:
;; Une simple traversée récursive terminale. La fonction s'arrête dès que
;; l'élément est trouvé, ce qui est efficace.
;;
;; Exemple: (member 'b '(a b c)) => #t
;;
(define (member element lst)
  (define (loop rest)
    (cond
      [(null? rest) #f]
      [(equal? (car rest) element) #t]
      [else (loop (cdr rest))]))
  (loop lst))

;; -----------------------------------------------------------------------------
;; Compte le nombre d'occurrences d'un élément dans une liste.
;;
;; Signature: (occur element lst) -> integer?
;; @param element: L'élément à compter.
;; @param lst: La liste à parcourir.
;; @return: Le nombre de fois que l'élément apparaît dans la liste.
;;
;; Logique:
;; Utilise une boucle récursive terminale avec un accumulateur `acc` qui est
;; incrémenté chaque fois que l'élément est trouvé.
;;
;; Exemple: (occur 'a '(a b a c a)) => 3
;;
(define (occur element lst)
  (define (loop rest acc)
    (cond
      [(null? rest) acc]
      [(equal? (car rest) element) (loop (cdr rest) (+ acc 1))]
      [else (loop (cdr rest) acc)]))
  (loop lst 0))
