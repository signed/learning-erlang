-module(ops).
-define(noMoreMagicNumbers, 42.0).
-define(sub(X, Y), X - Y).

-export([
  add/2,
  greet/0,
  macros/0
]).

-export([factorial/1]).

factorial(0) -> 1;
factorial(N) when N > 0 -> N * factorial(N - 1).

add(A, B) -> A + B.

macros() ->
  ?sub(add(2, 2) + ?noMoreMagicNumbers, ?noMoreMagicNumbers).

greet() ->
  io:format("Hello, world!~n").
