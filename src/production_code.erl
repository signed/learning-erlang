-module(production_code).

-export([
  no_argument/0,
  one_argument/1,
  two_arguments/2
]).

no_argument() ->
  the_real_thing.
one_argument(_One) ->
  the_real_thing.
two_arguments(_One, _Two) ->
  the_real_thing.