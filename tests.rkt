#lang racket

;; tests.rkt
;; Suite de tests unitaires pour le projet de programmation fonctionnelle

(require rackunit)
(require rackunit/text-ui)
(require "core-list.rkt")
(require "analyzer.rkt")
(require "library.rkt")

;; =============================================================================
;; TESTS POUR CORE-LIST.RKT
;; =============================================================================

(define core-list-tests
  (test-suite
   "Tests pour core-list.rkt"
   
   ;; Tests pour number-of-elements
   (test-case "number-of-elements: liste vide"
     (check-equal? (number-of-elements '()) 0))
   
   (test-case "number-of-elements: liste à un élément"
     (check-equal? (number-of-elements '(a)) 1))
   
   (test-case "number-of-elements: liste normale"
     (check-equal? (number-of-elements '(a b c d e)) 5))
   
   ;; Tests pour my-reverse
   (test-case "my-reverse: liste vide"
     (check-equal? (my-reverse '()) '()))
   
   (test-case "my-reverse: liste à un élément"
     (check-equal? (my-reverse '(a)) '(a)))
   
   (test-case "my-reverse: liste normale"
     (check-equal? (my-reverse '(a b c d)) '(d c b a)))
   
   (test-case "my-reverse: idempotence (double reverse)"
     (check-equal? (my-reverse (my-reverse '(a b c d))) '(a b c d)))
   
   ;; Tests pour member
   (test-case "member: élément présent"
     (check-equal? (member 'b '(a b c d)) #t))
   
   (test-case "member: élément absent"
     (check-equal? (member 'z '(a b c d)) #f))
   
   (test-case "member: élément en début de liste"
     (check-equal? (member 'a '(a b c d)) #t))
   
   (test-case "member: élément en fin de liste"
     (check-equal? (member 'd '(a b c d)) #t))
   
   (test-case "member: liste vide"
     (check-equal? (member 'a '()) #f))
   
   ;; Tests pour occur
   (test-case "occur: mot absent"
     (check-equal? (occur 'z '(a b c d)) 0))
   
   (test-case "occur: mot présent une fois"
     (check-equal? (occur 'b '(a b c d)) 1))
   
   (test-case "occur: mot présent plusieurs fois"
     (check-equal? (occur 'a '(a b a c a)) 3))
   
   (test-case "occur: liste vide"
     (check-equal? (occur 'a '()) 0))))

;; =============================================================================
;; TESTS POUR ANALYZER.RKT
;; =============================================================================

(define analyzer-tests
  (test-suite
   "Tests pour analyzer.rkt"
   
   ;; Tests pour doublons
   (test-case "doublons: liste sans doublons"
     (check-equal? (doublons '(a b c d)) '()))
   
   (test-case "doublons: liste avec quelques doublons"
     (check-equal? (sort (doublons '(a b a c b d)) symbol<?) '(a b)))
   
   (test-case "doublons: tous les éléments sont des doublons"
     (check-equal? (sort (doublons '(a a b b c c)) symbol<?) '(a b c)))
   
   (test-case "doublons: liste vide"
     (check-equal? (doublons '()) '()))
   
   ;; Tests pour unique
   (test-case "unique: liste avec doublons"
     (check-equal? (sort (unique '(a b a c b d)) symbol<?) '(a b c d)))
   
   (test-case "unique: liste déjà unique"
     (check-equal? (sort (unique '(a b c d)) symbol<?) '(a b c d)))
   
   (test-case "unique: liste vide"
     (check-equal? (unique '()) '()))
   
   ;; Tests pour frequence
   (test-case "frequence: cas simple"
     (let ([freq-result (frequence '(a b a c))])
       (check-equal? (length freq-result) 3)
       (check-equal? (assoc 'a freq-result) (cons 'a 2))
       (check-equal? (assoc 'b freq-result) (cons 'b 1))
       (check-equal? (assoc 'c freq-result) (cons 'c 1))))
   
   (test-case "frequence: vérification invariant somme = total"
     (let* ([test-list '(a b a c a b d)]
            [freq-result (frequence test-list)]
            [somme-freq (apply + (map cdr freq-result))]
            [taille-liste (number-of-elements test-list)])
       (check-equal? somme-freq taille-liste)))
   
   (test-case "frequence: liste vide"
     (check-equal? (frequence '()) '()))
   
   ;; Tests pour plus-frequent
   (test-case "plus-frequent: cas simple"
     (check-equal? (plus-frequent '(a b a c a)) (cons 'a 3)))
   
   (test-case "plus-frequent: cas d'égalité (ex æquo) - premier rencontré"
     (let ([result (plus-frequent '(a b a b c))])
       ;; Doit retourner soit (a . 2) soit (b . 2), mais de façon cohérente
       (check-true (or (equal? result (cons 'a 2))
                       (equal? result (cons 'b 2))))
       (check-equal? (cdr result) 2)))
   
   (test-case "plus-frequent: liste vide"
     (check-equal? (plus-frequent '()) '()))
   
   (test-case "plus-frequent: un seul élément"
     (check-equal? (plus-frequent '(x)) (cons 'x 1)))))

;; =============================================================================
;; TESTS POUR LIBRARY.RKT
;; =============================================================================

(define library-tests
  (test-suite
   "Tests pour library.rkt"
   
   ;; Données de test
   (let ([livre1 (livre "Test1" "Auteur1" #t)]
         [livre2 (livre "Test2" "Auteur1" #f)]
         [livre3 (livre "Test3" "Auteur2" #t)]
         [biblio-test (list (livre "Test1" "Auteur1" #t)
                           (livre "Test2" "Auteur1" #f)
                           (livre "Test3" "Auteur2" #t)
                           (livre "Test4" "Auteur2" #f))])
     
     ;; Tests pour auteur=?
     (test-case "auteur=?: auteur correct"
       (check-true (auteur=? livre1 "Auteur1")))
     
     (test-case "auteur=?: auteur incorrect"
       (check-false (auteur=? livre1 "Auteur2")))
     
     ;; Tests pour disponible?
     (test-case "disponible?: livre disponible"
       (check-true (disponible? livre1)))
     
     (test-case "disponible?: livre indisponible"
       (check-false (disponible? livre2)))
     
     ;; Tests pour livres-par-auteur
     (test-case "livres-par-auteur: auteur avec livres"
       (let ([livres-auteur1 (livres-par-auteur biblio-test "Auteur1")])
         (check-equal? (length livres-auteur1) 2)))
     
     (test-case "livres-par-auteur: auteur sans livres"
       (let ([livres-inexistant (livres-par-auteur biblio-test "AuteurInexistant")])
         (check-equal? (length livres-inexistant) 0)))
     
     ;; Tests pour livres-disponibles
     (test-case "livres-disponibles: filtrage correct"
       (let ([livres-dispo (livres-disponibles biblio-test)])
         (check-equal? (length livres-dispo) 2)
         (check-true (andmap disponible? livres-dispo))))
     
     ;; Test avec la bibliothèque d'exemple du projet
     (test-case "bibliotheque-exemple: structure correcte"
       (check-true (list? bibliotheque-exemple))
       (check-true (> (length bibliotheque-exemple) 0))
       (check-true (andmap list? bibliotheque-exemple))))))

;; =============================================================================
;; EXÉCUTION DES TESTS
;; =============================================================================

(define (run-all-tests)
  (printf "=== SUITE DE TESTS UNITAIRES ===~n~n")
  
  (printf "Exécution des tests core-list.rkt...~n")
  (run-tests core-list-tests)
  
  (printf "~nExécution des tests analyzer.rkt...~n")
  (run-tests analyzer-tests)
  
  (printf "~nExécution des tests library.rkt...~n")
  (run-tests library-tests)
  
  (printf "~n=== TESTS TERMINÉS ===~n"))

;; Exécution automatique lors du lancement du fichier
(run-all-tests)
