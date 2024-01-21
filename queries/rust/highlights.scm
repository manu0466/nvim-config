;; extends

; Check misspelled enum name.
(enum_item
  (type_identifier) @spell)

; Check misspelled enum variants.
(enum_variant) @spell

; Check misspelled structure definitions.
(struct_item
  (type_identifier) @spell)

; Check misspelled variables.
(field_declaration
  (field_identifier) @spell)

; Check misspelled functions.
(function_item
  (identifier) @spell)
; Check misspelled function parameters.
(function_item
  (parameters
    (parameter
      (identifier) @spell)))
