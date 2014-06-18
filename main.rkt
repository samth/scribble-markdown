#lang racket

(require markdown markdown/scrib
         (prefix-in sd: scribble/doclang2)
         scribble/base-render scribble/decode)

(provide (rename-out [mb #%module-begin]))

(define-syntax (mb stx)
  (syntax-case stx ()
    [(_ es)
     #`(sd:#%module-begin 
        (define datum 'es)
        (xexprs->scribble-pres datum))]))

(module reader syntax/module-reader
  scribble-md
  #:whole-body-readers? #t
  #:read (λ (p) (map syntax->datum (-read-syntax #f p)))
  #:read-syntax -read-syntax
   
  (require markdown)
  (define (-read-syntax name ip)
    (define xexprs (parameterize ([current-input-port ip])
                     (read-markdown)))
    (list xexprs))
  )