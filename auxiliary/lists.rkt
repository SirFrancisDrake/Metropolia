#lang racket
(provide
 rotate-right
 rotate-left
 rotate-left-times
 rotate-to-element
 rotate-to-predicate)

(require
  "numbers.rkt")

(define (snoc xs x)
  (append xs (list x)))

(define (drop-last xs)
  (if (null? (cdr xs))
      '()
      (cons (car xs) (drop-last (cdr xs)))))

(define (rotate-left lst)
  (if (null? lst)
      '()
      (snoc (cdr lst) (car lst))))

(define (rotate-right lst)
  (if (null? lst)
      '()
      (cons (last lst) (drop-last lst))))

(define (find-predicate pred lst)
  (define (fn c l)
    (cond
      ((pred (car l)) c)
      ((null? (cdr l)) #f)
      (else (fn (+ c 1) (cdr l)))))
    (fn 0 lst))

(define (find-x element lst)
  (find-predicate (lambda (x) (= x element)) lst))

(define (rotate-left-times times lst)
  (foldl (lambda (x acc) 
           (rotate-left acc))
         lst
         (range times)))

(define (rotate-to-predicate pred lst)
  (let ((pos (find-predicate pred lst)))
    (rotate-left-times pos lst)))

(define (rotate-to-element el lst)
  (rotate-to-predicate (lambda (t) (= el t)) lst))