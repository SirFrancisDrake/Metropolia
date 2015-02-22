#lang racket
(provide
 all-resources
 init-storage
 storage-values
 modify-resource!)

(define all-resources
  (list 'aluminum
        'water
        'oxygen
        'fuel
        'iron
        'silicon
        'carbon
        'electronics))

(define (init-storage)
  (define st (make-hash))
  (map (lambda (t) 
         (hash-set! st t 0)) 
       all-resources)
  st)

(define (storage-values st)
  (map (lambda (t)
         (list t (hash-ref st t)))
         all-resources))

(define (modify-resource! storage resource changer-fn)
  (define rval (hash-ref storage resource))
  (hash-set! storage resource (changer-fn rval)))