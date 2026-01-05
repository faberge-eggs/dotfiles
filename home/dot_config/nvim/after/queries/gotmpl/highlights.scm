; Go template highlight queries
; Based on actual gotmpl parser node types

; Actions
(if_action) @keyword
(else_action) @keyword
(end_action) @keyword
(range_action) @keyword
(with_action) @keyword
(define_action) @keyword
(template_action) @keyword
(block_action) @keyword

; Fields and variables (like .test, .onepassword.enabled)
(field
  name: (identifier) @property)

(variable) @variable

; Function calls
(function_call
  function: (identifier) @function)

; Identifiers
(identifier) @variable

; Strings
(interpreted_string_literal) @string

; Numbers
(int_literal) @number

; Text content (outside templates)
(text) @text

; Comments
(comment) @comment
