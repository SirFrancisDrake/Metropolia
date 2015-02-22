#lang racket
(require
  "../coordinates.rkt")

(provide
 make-height-map)

(define max-height 2)

(define (make-height-map size-x size-y)
  (define mp (make-hash))
  (for* ([x (range size-x)]
         [y (range size-y)])
    (hash-set! mp (point x y) (random (+ max-height 1))))
  mp)