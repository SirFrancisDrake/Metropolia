#lang racket
(require
  racket/gui
  racket/draw)

(provide
  screen%)

(define screen%
  (class object%
    (init-field canvas
                [x-offset 0]
                [y-offset 0])

    ; Called when the user pressed a key
    ; Should return the screen to use for the next tick (often 'this')
    (define/public (update key-event)
      (error 'screen% "override this method"))

    ; Called when the GUI needs to draw this screen
    ; Passed an ascii-canvas to draw to
    (define/public (draw canvas)
      (error 'screen% "override this method"))
    
    (super-new)))