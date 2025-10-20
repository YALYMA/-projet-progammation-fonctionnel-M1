#lang racket

;; Module library.rkt
;; Gestion d'une bibliotheque numerique

(provide livre
         auteur=?
         disponible?
         livres-par-auteur
         livres-disponibles
         afficher-livre
         afficher-liste-livres
         bibliotheque-exemple)

;; -----------------------------------------------------------------------------
;; Représentation des données
;;
;; Un "livre" est représenté par une liste de 3 éléments:
;; '(titre auteur disponible?)
;;   - titre: string?
;;   - auteur: string?
;;   - disponible?: boolean?
;; -----------------------------------------------------------------------------

;; Constructeur pour créer une structure de livre.
(define (livre titre auteur dispo)
  (list titre auteur dispo))

;; --- Accesseurs ---
(define (titre-livre livre) (car livre))
(define (auteur-livre livre) (cadr livre))
(define (dispo-livre livre) (caddr livre))

;; -----------------------------------------------------------------------------
;; Prédicat pour tester si un livre est d'un auteur donné.
;;
;; Signature: (auteur=? livre nom-auteur) -> boolean?
(define (auteur=? livre nom-auteur)
  (equal? (auteur-livre livre) nom-auteur))

;; -----------------------------------------------------------------------------
;; Prédicat pour tester si un livre est disponible.
;;
;; Signature: (disponible? livre) -> boolean?
(define (disponible? livre)
  (dispo-livre livre))

;; -----------------------------------------------------------------------------
;; Filtre une liste de livres pour ne garder que ceux d'un auteur spécifique.
;; Démontre l'utilisation de `filter` avec un prédicat personnalisé.
;;
;; Signature: (livres-par-auteur biblio nom-auteur) -> (listof livre?)
(define (livres-par-auteur biblio nom-auteur)
  (filter (lambda (livre) (auteur=? livre nom-auteur)) biblio))

;; -----------------------------------------------------------------------------
;; Filtre une liste de livres pour ne garder que ceux qui sont disponibles.
;;
;; Signature: (livres-disponibles biblio) -> (listof livre?)
(define (livres-disponibles biblio)
  (filter disponible? biblio))

;; --- Fonctions d'affichage ---

;; Affiche les informations d'un seul livre de manière formatée.
(define (afficher-livre livre)
  (printf "  - ~a, par ~a (~a)~n"
          (titre-livre livre)
          (auteur-livre livre)
          (if (disponible? livre) "disponible" "indisponible")))

;; Affiche une liste de livres en utilisant `afficher-livre` pour chaque élément.
(define (afficher-liste-livres livres)
  (if (null? livres)
      (printf "  (aucun livre trouvé)~n")
      (for-each afficher-livre livres)))

;; -----------------------------------------------------------------------------
;; Données d'exemple pour la démonstration et les tests.
;; Bibliothèque avec des auteurs sénégalais.
;;
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
