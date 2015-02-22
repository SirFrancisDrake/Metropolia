#lang racket
(require
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
    (define focus 'map)
    (define selected-tile (point 0 0))
    
    (define/override (draw canvas)
      (send canvas clear)
      
      (for* ([xi (in-range (send canvas get-width-in-characters))]
             [yi (in-range (send canvas get-height-in-characters))])
        (when (is-a-border? xi yi) (send canvas write #\# xi yi)))
      
      (send resource-screen draw-screen storage)
      (send status-screen draw-screen)
      (send map-screen draw-screen))
    
    (define/override (update key-event)
;      (case focus
;        ((resources)
;         (set! selected-resource
;               (case (send key-event get-key-code)
;                 [(numpad8 #\w up)    (send status-screen set-resource-mode
;                                            (send resource-screen move-cursor 'up))]
;                 [(numpad2 #\s down)  (send status-screen set-resource-mode
;                                            (send resource-screen move-cursor 'down))]
;                 [(numpad4 #\a left)  (send status-screen move-cursor 'left)]
;                 [(numpad6 #\d right) (send status-screen move-cursor 'right)])))
;        (else 
         (set! selected-tile
                (case (send key-event get-key-code)
                  [(numpad8 #\w up)    (send map-screen move-cursor 'up)]
                  [(numpad2 #\s down)  (send map-screen move-cursor 'down)]
                  [(numpad4 #\a left)  (send map-screen move-cursor 'left)]
                  [(numpad6 #\d right) (send map-screen move-cursor 'right)]))
    
    this)))

(define (is-a-border? x y)
  (or
   (and (= x resource-screen-width) (< y (- 36 status-screen-height)))
   (= y (- 36 status-screen-height))))