#lang racket
(provide
 dec inc)

(define (dec a)
  (- a 1))
(define (inc a)
  (+ a 1))