#lang racket
(require
  racket/gui
  racket/draw
  
  "ascii-canvas.rkt"
  "interface/screens/main-menu-screen.rkt"
  "interface/screen.rkt")

; create the GUI
(define gui%
  (class object%
    (init-field width-in-chars
                height-in-chars)
    
    ;create the frame
    (define frame
      (new frame%
           [label "Metropolia"]
           [style '(no-resize-border)]))
    
    (define canvas
      (new (class ascii-canvas%
             (inherit-field
              width-in-characters
              height-in-characters)
             
             ; Process keyboard events
             (define/override (on-char key-event)
               (case (send key-event get-key-code)
                 ; Exit the program
                 [(escape) (exit)]
                 ; Ignore key release events and pressing alt
                 [(release menu) (void)]
                 ; Pass everything along to the screen
                 ; Update the screen to whatever it returns
                 [else
                  (set! active-screen (send active-screen update key-event))
                  (cond
                    ; If it's still a valid screen, redraw it
                    [(is-a? active-screen screen%)
                     (send active-screen draw this)
                     (send frame refresh)]
                    ; Otherwise, exit the program
                    [else
                     (exit)])]))
             
             ; Initialize the ascii-canvas fields
             (super-new
              [parent frame]
              [width-in-characters width-in-chars]
              [height-in-characters height-in-chars])))) 
    
    (define active-screen (new main-menu-screen% [canvas canvas]))
    
    (send frame show #t)
    (send active-screen draw canvas)
    (send frame refresh)
    (super-new)))

(new gui%
     [width-in-chars 60]
     [height-in-chars 36])

