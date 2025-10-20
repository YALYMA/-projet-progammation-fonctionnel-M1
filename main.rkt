#lang racket

;; Fichier main.rkt
;; Point d'entrée principal pour démontrer les fonctionnalités

(require "core-list.rkt")
(require "analyzer.rkt")
(require "library.rkt")

;; -----------------------------------------------------------------------------
;; DONNÉES DE DÉMONSTRATION
;; -----------------------------------------------------------------------------

;; Une liste de mots utilisée pour la démonstration par défaut de l'analyseur.
(define texte-exemple
  '("je" "suis" "ici" "je" "code" "en" "racket" "je" "aime" "la" "programmation" "fonctionnelle"))

;; -----------------------------------------------------------------------------
;; FONCTIONS UTILITAIRES
;; -----------------------------------------------------------------------------

;; Fonction principale pour l'analyse d'une liste de mots.
;; Affiche un rapport complet des statistiques du texte.
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

;; Convertit une chaîne de caractères brute en une liste de mots propres.
;;   - Met tout en minuscule.
;;   - Extrait uniquement les séquences de lettres (et apostrophes).
(define (string->words str)
  (regexp-match* #px"[a-z']+" (string-downcase str)))

;; -----------------------------------------------------------------------------
;; POINT D'ENTRÉE PRINCIPAL
;; -----------------------------------------------------------------------------

;; Gère la logique principale du programme :
;; 1. Vérifie si des arguments sont passés en ligne de commande.
;; 2. Si oui, analyse le texte fourni.
;; 3. Si non, exécute la démonstration par défaut avec `texte-exemple`.
(define (main)
  (let ([args (current-command-line-arguments)])
    (if (vector-empty? args)
        ;; --- MODE DÉMONSTRATION ---
        (begin
          (printf "--- AUCUN TEXTE FOURNI EN ARGUMENT ---~n")
          (printf "Utilisation : make run TEXT=\"Votre phrase ici\"~n~n")
          (printf "Lancement de la démonstration par défaut...~n~n")
          
          (printf "--- ANALYSEUR DE TEXTE (DÉMONSTRATION) ---~n")
          (analyze-text texte-exemple)
          
          (printf "--- BIBLIOTHÈQUE NUMÉRIQUE (DÉMONSTRATION) ---~n")
          (printf "Livres par Ousmane Sembène :~n")
          (afficher-liste-livres (livres-par-auteur bibliotheque-exemple "Ousmane Sembène"))
          (printf "~nLivres disponibles :~n")
          (afficher-liste-livres (livres-disponibles bibliotheque-exemple)))
        
        ;; --- MODE LIGNE DE COMMANDE ---
        (begin
          (let* ([input-string (string-join (vector->list args) " ")]
                 [words (string->words input-string)])
            (printf "--- ANALYSEUR DE TEXTE (LIGNE DE COMMANDE) ---~n")
            (if (null? words)
                (printf "Aucun mot valide trouvé dans l'entrée fournie.~n")
                (analyze-text words)))))))

;; Exécution du programme principal au lancement du script.
(main)
