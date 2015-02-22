#lang racket
(provide
 point point-x point-y
 modify-x modify-y
 set-x set-y)

(define point make-rectangular)
(define point-x real-part)
(define point-y imag-part)

(define (modify-x fn pt)
  (point (fn (point-x pt))
         (point-y pt)))
(define (modify-y fn pt)
  (point (point-x pt)
         (fn (point-y pt))))

(define (set-x x pt)
  (modify-x (const x) pt))
(define (set-y y pt)
  (modify-y (const y) pt))