#lang racket
(require
  "auxiliary/lists.rkt"
  "coordinates.rkt"
  "interface/screens/map.rkt"
  "interface/screens/resources.rkt"
  "interface/screens/status.rkt"
  "world/resources.rkt"
  "screen.rkt")

(provide
 game-screen%)

(define resource-screen-width 8)
(define status-screen-height 6)

(define game-screen%
  (class screen%
    (super-new)
    (inherit-field canvas x-offset y-offset)
    
    (define screen-state
      (new (class object%
             (super-new)
             
             (define focus (list 'map 'resources))
             (define selected-tile (point 0 0))
             (define selected-resource 'none)
             
             (define/public (get-focus)
               (car focus))
             (define/public (set-focus screen)
               (let ((new-focus-list (rotate-to-element screen)))
                 (set! focus new-focus-list)))
             
             (define/public (get-selected-resource)
               selected-resource)
             (define/public (set-selected-resource res)
               (set! selected-resource res))
             
             (define/public (get-selected-tile)
               selected-tile)
             (define/public (set-selected-tile tile)
               (set! selected-tile tile))
             
             (define/public (rotate-focus)
               (set! focus (rotate-left focus))
               (car focus)))))
    
    (define resource-screen (new resource-screen% [canvas canvas]))
    (define status-screen (new status-screen% 
                               [canvas canvas]
                               [y-offset (- 36 status-screen-height)]))
    (define map-screen (new map-screen%
                            [canvas canvas]
                            [x-offset (+ resource-screen-width 1)]
                            [width 51]
                            [height 30]))
    (define selected-resource 'nothing)
    (define storage (init-storage)) ;FIXME default storage
    
    (define/override (draw canvas)
      (send canvas clear)
      
      (for* ([xi (in-range (send canvas get-width-in-characters))]
             [yi (in-range (send canvas get-height-in-characters))])
        (when (is-a-border? xi yi) (send canvas write #\# xi yi)))
      
      (send resource-screen draw-screen storage)
      (send status-screen draw-screen)
      (send map-screen draw-screen))
    
    (define/override (update key-event)
      (let ((key-code (send key-event get-key-code)))
        (case key-code
          [(#\tab) (send screen-state rotate-focus)]
          [else
           (case (send screen-state get-focus)
             ((resources)
              (send screen-state set-selected-resource
                    (case key-code
                      [(numpad8 #\w up)    (send status-screen set-resource-mode
                                                 (send resource-screen move-cursor 'up))]
                      [(numpad2 #\s down)  (send status-screen set-resource-mode
                                                 (send resource-screen move-cursor 'down))]
                      [(numpad4 #\a left)  (send status-screen move-cursor 'left)]
                      [(numpad6 #\d right) (send status-screen move-cursor 'right)])))
             (else 
              (send screen-state set-selected-tile
                    (case key-code
                      [(numpad8 #\w up)    (send map-screen move-cursor 'up)]
                      [(numpad2 #\s down #\tab)  (send map-screen move-cursor 'down)]
                      [(numpad4 #\a left)  (send map-screen move-cursor 'left)]
                      [(numpad6 #\d right) (send map-screen move-cursor 'right)]))))]))
      
      this)))

(define (is-a-border? x y)
  (or
   (and (= x resource-screen-width) (< y (- 36 status-screen-height)))
   (= y (- 36 status-screen-height))))