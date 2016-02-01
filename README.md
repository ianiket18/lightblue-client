[![Build Status](https://travis-ci.org/jturel/lightblue-client.svg?branch=master)](https://travis-ci.org/jturel/lightblue-client)
# Lightblue::Client

A Ruby query builder and client for [Lightblue][]. The focus has so far been towards taking advantage of the rich query interface provided by [Lightblue][], and it 

1. Expressions are highly composable, which facilitates code reuse and legibility in addition to allowing queries to be built dynamically by your application.
2. Expressions are backed by an AST, which currently provides syntactic validation against the Lightblue specification, as well as decent hinting and error messaging. Long term goals here involve leveraging Lightblue's introspective capabilities (metadata, schema, etc) to provide code gen (either AOT from a local schema or dynamically by consuming metadata from a host), auto-completion, and some level of semantic validation.

[Lightblue]: (https://github.com/lightblue-platform)
[Arel]: (https://github.com/rails/arel)

# Usage 

```ruby
   foo = Lightblue::Entity.new(:foo)
   foo.find{ field[:baz].eq(10) }.to_hash
   => {:op=>"$eq", :field=>:baz, :rvalue=>10}

query =
  entity.find do
  field[:bar]
    .eq(:foo)
    .all(field[:baz]
          .eq(field[:gorp])
          .or(field[:scrim].eq(:scram)))
end.project do
  field(:bar).match(entity.find { field[:flim].eq(:flam) })
end
```

query.to_hash
=>
{ entity: :foo,
  query:
    { :$all =>
      [
        { op:  :$eq, field:  :bar, rvalue:  :foo },
        { :$or =>
               [
                 { op:  :$eq, field:  :baz, rfield:  :gorp },
                 { op:  :$eq, field:  :scrim, rvalue:  :scram }
               ]
        }
      ]
  },
  projection: {
    field: :bar,
    include: true,
    match: {
      field: :flim,
      op: :$eq,
      rvalue: :flam }
  }
}
```

Take a look at specs/lightblue/query_spec.rb for better examples
https://github.com/daviswahl/lightblue-client/blob/master/spec/lightblue/query_spec.rb

TODO:

Add nodes for the rest of the tokens outlined in the spec: http://jewzaam.gitbooks.io/lightblue-specifications/content/language_specification/search_criteria.html

Add update/create/delete

See what can be done with metadata

Entities are currently arbitrary. They could be linked to a schema, although I'm not sure if it would benefit the AST.
I don't fully understand how Lightblue does field comparisons (can you compare foo_entity[:field] to bar_entity[:field] ?). Need to experiment with this and consider some kind of join syntax.
