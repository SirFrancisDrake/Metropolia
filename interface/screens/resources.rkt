#lang racket
(require
  "../../world/resources.rkt"
  "../screen.rkt"
  "../resources.rkt")

(provide
 resource-screen%)

(define resource-screen%
  (class screen%
    (inherit-field canvas)
    (inherit focus unfocus focused?)
    
    (define left-offset 1)
    (define top-offset 1)
    (define cutoff-position 4)
    
    (define list-length (length all-resources))
    (define cursor-position 0)
    
    (define/public (move-cursor direction)
      (case direction
        [(up)
         (when (> cursor-position 0)
           (set! cursor-position (- cursor-position 1)))]
        [(down)
         (when (< cursor-position (- list-length 1))
           (set! cursor-position (+ cursor-position 1)))])
      (list-ref all-resources cursor-position))
    
    (define/override (draw storage)
      (define cnv
        (for/list ([counter (in-naturals top-offset)]
                   [pair (name-value storage)])
          (cons counter pair)))
      
      (map (lambda (triple)
             (send canvas write-string 
                   (string-append (substring (cadr triple) 0 cutoff-position)
                                  " "
                                  (number->string (caddr triple)))
                   left-offset
                   (car triple)))
           cnv)
      (send this draw-cursor canvas cursor-position))
    
    (define/public (draw-cursor canvas position)
      (define cursor-color
        (if (send this focused?)
            "white"
            "dimgray"))
      (send canvas write #\> (- left-offset 1) (+ top-offset position) cursor-color))
    
    (super-new)))