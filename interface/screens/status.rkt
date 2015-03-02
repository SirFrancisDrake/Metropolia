#lang racket
(require
  "../screen.rkt")

(provide
 status-screen%)

(define button-size 10)

(define status-screen%
  (class screen%
    (inherit-field canvas x-offset y-offset)
    (super-new)
    
    (define screen-state
      (new (class object%
             (super-new)
             
             (define caption "no mode")
             (define buttons (list 'un 'deux 'trois))
             (define cursor-position 0)
             
             (define/public (move-cursor direction)
               (case direction
                 [(left)
                  (when (> cursor-position 0)
                    (set! cursor-position (- cursor-position 1)))]
                 [(right)
                  (when (< cursor-position (- (length buttons) 1))
                    (set! cursor-position (+ cursor-position 1)))]))
             
             (define/public (get-cursor-position) cursor-position)
             (define/public (get-buttons) buttons)
             (define/public (get-caption) caption)
             
             (define/public (resource-mode resource)
               (set! buttons (list 'buy 'sell))
               (set! caption (symbol->string resource))
               (when (>= cursor-position (length buttons))
                 (set! cursor-position 0))))))

    (define/public (set-resource-mode resource)
      (send screen-state resource-mode resource)
      (send this draw))
    
    (define/public (move-cursor direction)
      (send screen-state move-cursor direction)
      (send this draw-cursor))
    
    (define/override (draw)
      (let ([buttons (send screen-state get-buttons)])
        (for/list ([c (in-naturals 0)]
                   [b buttons])
      (let ([x (+ x-offset 2 (* button-size c))]
            [y (+ y-offset 4)])
        (send canvas write-string (symbol->string b) x y))))
      (send canvas write-string (send screen-state get-caption) (+ x-offset 1) (+ y-offset 2))
      (send this draw-cursor))
          
    (define/public (draw-cursor)
      (let ([x (+ x-offset 1 (* 10 (send screen-state get-cursor-position)))]
            [y (+ y-offset 4)]
            [cursor-color (if (send this focused?)
                              "white"
                              "dimgray")])
        (send canvas write #\> x y cursor-color)))))