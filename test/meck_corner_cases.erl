-module(meck_corner_cases).
-include_lib("eunit/include/eunit.hrl").

% https://stackoverflow.com/questions/43279705/whats-the-point-of-meckvalidate
validate_is_of_limited_use_test_() ->
  {foreach, fun setup_mock/0, fun cleanup_mock/1,
    [
      fun validate_does_not_fail_if_a_function_is_not_called/0,
      fun validate_does_not_fail_if_a_function_is_called_with_wrong_arity/0,
      fun validate_does_not_fail_if_an_undefined_function_is_called/0,
      fun validate_does_fail_if_a_function_was_called_with_wrong_argument_types/0,
      fun validate_does_fail_if_expectation_throws_an_unexpected_exception/0
    ]
  }.

validate_does_not_fail_if_a_function_is_not_called() ->
  meck:expect(womble, name, fun() -> "Wellington" end),
  ?assert(meck:validate(womble)).

validate_does_not_fail_if_a_function_is_called_with_wrong_arity() ->
  meck:expect(womble, name, fun() -> "Madame Cholet" end),
  ?assertError(undef, womble:name(unexpected_arg)),
  ?assert(meck:validate(womble)).

validate_does_not_fail_if_an_undefined_function_is_called() ->
  ?assertError(undef, womble:fly()),
  ?assert(meck:validate(womble)).

validate_does_fail_if_a_function_was_called_with_wrong_argument_types() ->
  meck:expect(womble, jump, fun(Height) when Height < 1 ->
    ok
                            end),
  ?assertError(function_clause, womble:jump(999)),
  ?assertNot(meck:validate(womble)).

validate_does_fail_if_expectation_throws_an_unexpected_exception() ->
  meck:expect(womble, jump, fun(Height) -> 42 = Height end),
  ?assertError({badmatch, 999}, womble:jump(999)),
  ?assertNot(meck:validate(womble)).

setup_mock() ->
  meck:new(womble, [non_strict]).

cleanup_mock(_SetupResult) ->
  meck:unload(womble).