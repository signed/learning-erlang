-module(production_code).
-export([]).

-export([
  no_argument/0,
  one_argument/1
]).

no_argument() ->
  the_real_thing.
one_argument(_One) ->
  the_real_thing.
