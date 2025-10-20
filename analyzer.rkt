#lang racket

;; Module analyzer.rkt
;; Fonctions d'analyse de texte basées sur les fonctions de core-list

(require "core-list.rkt")

(provide doublons
         unique
         frequence
         plus-frequent
         trier-par-frequence
         filtre-longueur)

;; --- Fonctions optimisées (Passe unique) ---

;; -----------------------------------------------------------------------------
;; Construit une table de fréquences (liste d'association) en une seule passe.
;; C'est la fonction centrale optimisée qui rend les autres analyses performantes.
;;
;; Signature: (build-freq-map lst) -> (listof (cons string? integer?))
;; @param lst: La liste de mots (chaînes de caractères) à analyser.
;; @return: Une liste d'association `'(("mot" . compte)...)` non ordonnée.
;;
;; Logique (O(n)):
;; La fonction parcourt la liste de mots une seule fois. Pour chaque mot :
;; - Si le mot est déjà dans l'accumulateur `acc`, sa paire est mise à jour.
;; - Sinon, une nouvelle paire `(mot . 1)` est ajoutée.
;; `assoc` permet de retrouver une paire existante. `remove` et `cons` sont
;; utilisés pour mettre à jour l'accumulateur de manière fonctionnelle.
;;
;; Exemple: (build-freq-map '("a" "b" "a")) => '(("b" . 1) ("a" . 2))
;;
(define (build-freq-map lst)
  (define (loop rest acc)
    (if (null? rest)
        acc
        (let* ([mot (car rest)]
               [paire (assoc mot acc)])
          (if paire
              (loop (cdr rest) (cons (cons mot (+ (cdr paire) 1)) (remove paire acc)))
              (loop (cdr rest) (cons (cons mot 1) acc))))))
  (loop lst '()))

;; -----------------------------------------------------------------------------
;; Calcule la fréquence de chaque mot dans une liste.
;;
;; Signature: (frequence lst) -> (listof (cons string? integer?))
;; @param lst: La liste de mots.
;; @return: La table de fréquences, ordonnée par apparition des mots.
;;
(define (frequence lst)
  (my-reverse (build-freq-map lst)))

;; -----------------------------------------------------------------------------
;; Retourne la liste des mots uniques (supprime les doublons).
;;
;; Signature: (unique lst) -> (listof string?)
;; @param lst: La liste de mots.
;; @return: La liste des mots uniques, dans leur ordre d'apparition.
;;
(define (unique lst)
  (map car (frequence lst)))

;; -----------------------------------------------------------------------------
;; Extrait les mots qui apparaissent plus d'une fois dans la liste.
;;
;; Signature: (doublons lst) -> (listof string?)
;; @param lst: La liste de mots.
;; @return: La liste des mots qui sont des doublons (sans ordre garanti).
;;
(define (doublons lst)
  (let ([freq-map (build-freq-map lst)])
    (let loop ([rest freq-map] [acc '()])
      (if (null? rest)
          acc
          (let* ([paire (car rest)]
                 [count (cdr paire)])
            (if (> count 1)
                (loop (cdr rest) (cons (car paire) acc))
                (loop (cdr rest) acc)))))))

;; -----------------------------------------------------------------------------
;; Trouve le mot (ou la paire `mot . compte`) le plus fréquent dans une liste.
;;
;; Signature: (plus-frequent lst) -> (cons string? integer?) or '()
;; @param lst: La liste de mots.
;; @return: La première paire `(mot . compte)` la plus fréquente, ou '() si la liste est vide.
;;
;; Gestion des ex æquo:
;; Si plusieurs mots ont la même fréquence maximale, la fonction retourne le premier
;; qu'elle rencontre dans la liste des fréquences, ce qui correspond au premier
;; mot unique apparu dans le texte original.
;;
(define (plus-frequent lst)
  (let ([freq-list (frequence lst)])
    (if (null? freq-list)
        '()
        (let loop ([rest (cdr freq-list)] [max-pair (car freq-list)])
          (cond
            [(null? rest) max-pair]
            [(> (cdr (car rest)) (cdr max-pair))
             (loop (cdr rest) (car rest))]
            [else (loop (cdr rest) max-pair)])))))

;; -----------------------------------------------------------------------------
;; EXTENSIONS : Tri par fréquence et filtrage par longueur
;; -----------------------------------------------------------------------------

;; Trie une liste de paires (mot . count) par ordre décroissant de fréquence.
;; Utilise un tri par insertion récursif terminal.
;;
;; Signature: (trier-par-frequence lst) -> (listof (cons string? integer?))
(define (trier-par-frequence lst)
  ;; Insère une paire dans une liste déjà triée
  (define (inserer paire liste-triee)
    (cond
      [(null? liste-triee) (list paire)]
      [(>= (cdr paire) (cdr (car liste-triee)))
       (cons paire liste-triee)]
      [else (cons (car liste-triee) (inserer paire (cdr liste-triee)))]))
  
  ;; Boucle principale de tri par insertion
  (define (loop rest acc)
    (if (null? rest)
        acc
        (loop (cdr rest) (inserer (car rest) acc))))
  
  (loop lst '()))

;; Filtre une liste de mots pour ne garder que ceux d'une longueur minimale.
;; 
;; Signature: (filtre-longueur lst longueur-min) -> (listof string?)
(define (filtre-longueur lst longueur-min)
  (define (loop rest acc)
    (cond
      [(null? rest) (my-reverse acc)]
      [(>= (string-length (car rest)) longueur-min)
       (loop (cdr rest) (cons (car rest) acc))]
      [else (loop (cdr rest) acc)]))
  (loop lst '()))
