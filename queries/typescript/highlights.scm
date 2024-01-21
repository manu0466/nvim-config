;; extends

; Check misspelled enum declarations.
(enum_declaration
  (identifier) @spell)
; Check misspelled enum variants.
(enum_assignment
  (property_identifier) @spell)
(enum_body
  (property_identifier) @spell)

; Check misspelled interfaces.
(interface_declaration
  (type_identifier) @spell)
; Check misspelled interface properties.
(property_signature
  (property_identifier) @spell)

; Check misspelled classes.
(class_declaration
 (type_identifier) @spell)
; Check misspelled class properties.
(class_body
  (_ 
   (property_identifier) @spell)
     (#not-eq? @spell "constructor"))

; Check misspelled variables.
(lexical_declaration
  (variable_declarator
    (identifier) @spell))

; Check misspelled functions.
(function_declaration
  (identifier) @spell)
; Check misspelled function parameters
(formal_parameters
  (_ 
    (identifier) @spell))
