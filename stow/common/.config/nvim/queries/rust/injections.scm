; extends
((string_literal) @injection.content
(#match? @injection.content"(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by)?")
(#offset! @injection.content 0 1 0 -1)
(#set! injection.include-children)
(#set! injection.language "sql"))
