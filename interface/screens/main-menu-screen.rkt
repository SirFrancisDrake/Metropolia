#lang racket
(require
  "../screen.rkt"
  "game-screen.rkt")

(provide
 main-menu-screen%)

(define main-menu-screen%
  (class screen%
    (super-new)
    (inherit-field canvas
                   x-offset
                   y-offset)
    
    ; Always turn control over the game screen
    (define/override (update key-event)
      (new game-screen% (canvas canvas)))
  
  ; Just draw a basic menu
  (define/override (draw canvas)
    (send canvas clear)
    (send canvas write-center "Metropolia: an Offworld Trading Clone" 10)
    (send canvas write-center "Press any key to start" 12))))