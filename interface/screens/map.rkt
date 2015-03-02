#lang racket
(require
  "../../auxiliary/coordinates.rkt"
  "../../auxiliary/numbers.rkt"
  "../../world/height-map.rkt"
  "../screen.rkt")

(provide
 map-screen%)

(define (recog s)
  (case s
    [(0) #\0]
    [(1) #\1]
    [(2) #\2]))

(define map-screen%
  (class screen%
    (init-field width height)
    (super-new)
    (inherit-field canvas x-offset y-offset focused)
    (inherit focus unfocus focused?)
    
    (define screen-state
      (new (class object%
             (super-new)
             
             (define cursor-position (point 0 0))
             
             (define/public (move-cursor direction)
               (case direction
                 [(left)
                  (when (> (point-x cursor-position) 0)
                    (set! cursor-position (modify-x dec cursor-position)))]
                 [(right)
                  (when (< (point-x cursor-position) (- width 1))
                    (set! cursor-position (modify-x inc cursor-position)))]
                 [(up)
                  (when (> (point-y cursor-position) 0)
                    (set! cursor-position (modify-y dec cursor-position)))]
                 [(down)
                  (when (< (point-y cursor-position) (- height 1))
                    (set! cursor-position (modify-y inc cursor-position)))])
               cursor-position)
             
             (define/public (get-cursor-position) cursor-position))))
    
    (define height-map (make-height-map width height))
    
    (define/public (move-cursor direction)
      (define a (send screen-state move-cursor direction))
      (send this draw)
      a)
    
    (define (cursor-background)
      (let ((have-focus (send this focused?)))
        (if have-focus
            "green"
            "red")))
    
    (define/override (draw)
      (for* ([xi (in-range width)]
             [yi (in-range height)])
        (let ([x (+ x-offset xi)]
              [y (+ y-offset yi)])
          (if (equal? (point xi yi) (send screen-state get-cursor-position))
              (send canvas write 
                    (recog (hash-ref height-map (point xi yi)))
                    x
                    y
                    "blue"
                    (cursor-background))
              (send canvas write 
                    (recog (hash-ref height-map (point xi yi)))
                    x
                    y
                    "blue")))))))