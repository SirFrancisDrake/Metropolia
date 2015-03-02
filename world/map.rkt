#lang racket
(provide
 resource-deposit
 adjacency-bonus
 building)

(require
  "../auxiliary/coordinates.rkt")

(define map-width 36) ; FIXME global const
(define map-height 12);

(struct resource-deposit (resource level))
(struct adjacency-bonus (number-of-buildings amount))
(struct building (deposit adjacency-bonus income))

; example
;(define a (building (resource-deposit 'water 3) 
;                    (adjacency-bonus 0 0) 
;                    0.5))

; diagonal counts as adjacent
(define (cells-adjacent? a b)
  (let ((dist (distance a b)))
    (and (> dist 0)
         (< dist 2))))

; provides the list of all points adjacent to a given one
; that fit on the map. Relies on map-width and map-height in scope
(define (adjacent-coordinates x y)
  (let* ((pre-differences (map (lambda (t) (list (quotient t 3)
                                                 (remainder t 3)))
                               (range 0 9)))
         (differences (map (lambda (a) (list (- (car a) 1) (- (cadr a) 1))) pre-differences))
         (adjacent-dirty (map (lambda (a)
                                (list (+ (car a) x)
                                      (+ (cadr a) y)))
                              differences)))
    (define (filter-fn pair)
      (and (>= (car pair) 0)
           (>= (cadr pair) 0)
           (<= (car pair) map-width)
           (<= (cadr pair) map-height)
           (not (equal? pair (list x y)))))
    (filter filter-fn adjacent-dirty)))
         
         (define (count-adjacency-bonus a-map x y)
           #t)