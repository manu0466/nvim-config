;; extends

; Check misspelled variables.
(variable_list
  (identifier) @spell)

; Check misspelled fields.
(field
  (identifier) @spell)

; Check misspelled functions.
(function_declaration
  (identifier) @spell)
; Check misspelled functions parameters.
(function_definition
  (parameters
    (identifier) @spell))
