-module(pattern_matching).

-export([
  one/3
]).

one(_Atom, true, _User) ->
  <<"the true one">>;
one(_Atom, _Any, _User) ->
  <<"the false one">>.
