-module(ops_tests).
-include_lib("eunit/include/eunit.hrl").

add_test() ->
  4 = ops:add(2, 2).

factorial_test() ->
  ?assertEqual(6, ops:factorial(3)).

new_add_test() ->
  ?assertEqual(4, ops:add(2, 2)),
  ?assertEqual(3, ops:add(1, 2)),
  ?assert(is_number(ops:add(1, 2))),
  ?assertEqual(2, ops:add(1, 1)),
  ?assertError(badarith, 1 / 0).

add_test_() ->
  [test_them_types(),
    test_them_values(),
    ?_assertError(badarith, 1 / 0)].

test_them_types() ->
  ?_assert(is_number(ops:add(1, 2))).

test_them_values() ->
  [
    ?_assertEqual(4, ops:add(2, 2)),
    ?_assertEqual(3, ops:add(1, 2)),
    ?_assertEqual(2, ops:add(1, 1))
  ].

inc_test_() ->
  [
    {"one to go", fun() -> ?assertEqual(1, 1) end},
    {"two to go", ?_test(?assertEqual(2, 2))}
  ].

basic_ops_test_() ->
  fun() -> ?assert(1 + 3 =:= 4) end.

basic_macro_test_() ->
  ?_test(?assert(1 + 1 =:= 2)).

basic_macro_even_shorter_test_() ->
  ?_assert(1 + 1 =:= 2).

all_the_basics_test_() ->
  [
    fun() -> ?assert(1 + 3 =:= 4) end,
    ?_test(?assert(1 + 1 =:= 2)),
    ?_assert(1 + 1 =:= 2)
  ].

debug_macros_test_() ->
  One = 1,
  Two = 2,
  ?debugHere,
  ?debugFmt("Look at ~p.~n", [<<"me">>]),
  ?debugMsg("Look at me"),
  ?debugVal(One + Two),
  ?_assert(true).

test_sets_test_() ->
  {"catch", fun() -> 2 = 2 end},
  {"me", fun() -> 2 = 2 end}.


inc_setup() -> return_value_from_setup.

inc_cleanup(return_value_from_setup) -> ok.

inc_fixture_test_() ->
  {foreach,
    fun inc_setup/0,
    fun inc_cleanup/1,
    [
      {"inc by 0", ?_test(
        ?assertEqual(1, 1))
      }
    ]
  }.