#lang racket
(require
  "../world/resources.rkt")

(provide
 name-value
 debug-storage)

(define (storage-to-show-pairs st)
  (map (lambda (res)
         (list (symbol->string res)
               (hash-ref st res)))
       all-resources))

(define (name-value st)
  (define (get-resource-pairs)
    (map (lambda (r)
           (list (symbol->string r)
                 (hash-ref st r)))
         all-resources))
  (for/list ([pair (get-resource-pairs)])
    (list (car pair)
          (cadr pair))))

(define debug-storage (init-storage))