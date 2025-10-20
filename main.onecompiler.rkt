#lang racket

;; -----------------------------------------------------------------------------
;; 1. Fonctions utiles pour manipuler les listes et l'analyse de texte
;; -----------------------------------------------------------------------------

;; Inverse l'ordre des éléments d'une liste.
(define (my-reverse lst)
  (define (loop rest acc)
    (if (null? rest)
        acc
        (loop (cdr rest) (cons (car rest) acc))))
  (loop lst '()))

;; Compte le nombre d'éléments dans une liste.
(define (number-of-elements lst)
  (define (loop rest acc)
    (if (null? rest)
        acc
        (loop (cdr rest) (+ acc 1))))
  (loop lst 0))

;; Vérifie si un élément est présent dans une liste.
(define (member element lst)
  (define (loop rest)
    (cond
      [(null? rest) #f]
      [(equal? (car rest) element) #t]
      [else (loop (cdr rest))]))
  (loop lst))

;; Compte le nombre d'occurrences d'un élément dans une liste.
(define (occur element lst)
  (define (loop rest acc)
    (cond
      [(null? rest) acc]
      [(equal? (car rest) element) (loop (cdr rest) (+ acc 1))]
      [else (loop (cdr rest) acc)]))
  (loop lst 0))

;; -----------------------------------------------------------------------------
;; 2. Fonctions d'analyse de texte (fréquences, doublons, uniques)
;; -----------------------------------------------------------------------------

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

(define (frequence lst)
  (my-reverse (build-freq-map lst)))

(define (unique lst)
  (map car (frequence lst)))

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
;; Signature: (filtre-longueur lst longueur-min) -> (listof string?)
(define (filtre-longueur lst longueur-min)
  (define (loop rest acc)
    (cond
      [(null? rest) (my-reverse acc)]
      [(>= (string-length (car rest)) longueur-min)
       (loop (cdr rest) (cons (car rest) acc))]
      [else (loop (cdr rest) acc)]))
  (loop lst '()))

;; Prend une string et retourne une liste de mots nettoyés (lettres ou apostrophes, minuscules)
(define (string->words str)
  (regexp-match* #px"[a-z']+" (string-downcase str)))

;; -----------------------------------------------------------------------------
;; 3. Données et gestion des livres de bibliothèque (peuvent être supprimés pour analyse pur texte)
;; -----------------------------------------------------------------------------

;; Constructeur pour créer une structure de livre.
(define (livre titre auteur dispo)
  (list titre auteur dispo))

;; Accesseurs
(define (titre-livre livre) (car livre))
(define (auteur-livre livre) (cadr livre))
(define (dispo-livre livre) (caddr livre))

;; Prédicats et filtres
(define (auteur=? livre nom-auteur)
  (equal? (auteur-livre livre) nom-auteur))

(define (disponible? livre)
  (dispo-livre livre))

(define (livres-par-auteur biblio nom-auteur)
  (filter (lambda (livre) (auteur=? livre nom-auteur)) biblio))

(define (livres-disponibles biblio)
  (filter disponible? biblio))

;; Fonctions d'affichage livres
(define (afficher-livre livre)
  (printf "  - ~a, par ~a (~a)~n"
          (titre-livre livre)
          (auteur-livre livre)
          (if (disponible? livre) "disponible" "indisponible")))

(define (afficher-liste-livres livres)
  (if (null? livres)
      (printf "  (aucun livre trouvé)~n")
      (for-each afficher-livre livres)))

;; Exemple de bibliothèque avec des auteurs sénégalais
(define bibliotheque-exemple
  (list
    (livre "Une si longue lettre" "Mariama Bâ" #t)
    (livre "Un chant écarlate" "Mariama Bâ" #f)
    (livre "L'Aventure ambiguë" "Cheikh Hamidou Kane" #t)
    (livre "Les Bouts de bois de Dieu" "Ousmane Sembène" #t)
    (livre "Le Docker noir" "Ousmane Sembène" #f)
    (livre "Xala" "Ousmane Sembène" #t)
    (livre "La Grève des bàttu" "Aminata Sow Fall" #f)
    (livre "L'Appel des arènes" "Aminata Sow Fall" #t)
    (livre "Le Ventre de l'Atlantique" "Fatou Diome" #t)
    (livre "Murambi, le livre des ossements" "Boubacar Boris Diop" #t)))

;; -----------------------------------------------------------------------------
;; 4. Rapport d'analyse de texte
;; -----------------------------------------------------------------------------

(define (analyze-text lst-mots)
  (printf "Texte analysé : ~a~n~n" lst-mots)
  (printf "  - Nombre total de mots : ~a~n" (number-of-elements lst-mots))
  (printf "  - Liste inversée : ~a~n" (my-reverse lst-mots))
  (printf "  - Mots uniques : ~a~n" (unique lst-mots))
  (printf "  - Doublons : ~a~n" (doublons lst-mots))
  (printf "  - Fréquences : ~a~n" (frequence lst-mots))
  (printf "  - Mot le plus fréquent : ~a~n" (plus-frequent lst-mots))
  (printf "~n  === EXTENSIONS ===~n")
  (printf "  - Fréquences triées (décroissant) : ~a~n" (trier-par-frequence (frequence lst-mots)))
  (printf "  - Mots de 5+ lettres : ~a~n~n" (filtre-longueur lst-mots 5)))

;; -----------------------------------------------------------------------------
;; 5. Point d'entrée principal : lecture du texte depuis stdin
;; -----------------------------------------------------------------------------

(define (main)
  (printf "Veuillez entrer un texte puis valider (entrée):~n")
  (let* ([input-string (read-line)]
         [words (string->words input-string)])
    (if (null? words)
        (begin
          (printf "~nAucun mot valide trouvé dans l'entrée.~n"))
        (begin
          (printf "--- ANALYSEUR DE TEXTE (ENTRÉE UTILISATEUR) ---~n")
          (analyze-text words)))

    (printf "--- BIBLIOTHÈQUE NUMÉRIQUE (EXEMPLE) ---~n")
    (printf "Livres par Ousmane Sembène :~n")
    (afficher-liste-livres (livres-par-auteur bibliotheque-exemple "Ousmane Sembène"))
    (printf "~nLivres disponibles :~n")
    (afficher-liste-livres (livres-disponibles bibliotheque-exemple))))

;; -----------------------------------------------------------------------------
;; 6. Lance l'exécution automatiquement
;; -----------------------------------------------------------------------------

(main)
