# Notes

## Todos



- [ ]  auto-patch @ivars
  - patch line-by-line and skip comment lines!!
    - avoids / skips comments such as # @sig :-)
      e.g. auto-patching contract code >@sig< to >storage[ :sig ]<


- [ ] assert
  - add optional message e.g.
    assert challenger != host, "challenger shouldn't be the same as host"

- [ ] safestruct - hash 
  - handle anonymous value class in build_class 
    use define_singleton_method instead of eval with string

```
ef setup
  # @games = Mapping.of( Address => Mapping.of( Address => Game ))
  h = Mapping.of( Address => Game )
  @games = Mapping.of( Address => h.class )
end


[debug] SafeHash - build_class klass_value:
#<Class:0x4dc46f0>
safestruct-1.2.0/lib/safestruct/safe_hash.rb:37:in `class_eval': (eval):6: syntax error, unexpected keyword_end (SyntaxError)
        from safestruct-1.2.0/lib/safestruct/safe_hash.rb:37:in `build_class'
        from safestruct-1.2.0/lib/safestruct.rb:56:in `of'
        from (eval):20:in `setup'
```

- [ ] Turn Universum class into a module/namespace - namespace everything with Universum module.
- [ ] Move all support classes e.g. Event, Struct, Enum, etc. into the Universum namespace/module.


