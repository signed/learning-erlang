-module(production_code_tests).

-include_lib("eunit/include/eunit.hrl").

fixture_test_() ->
  {foreach,
    fun setup/0,
    fun cleanup/1,
    [
      {"mock function with no argument", ?_test(
        begin
          meck:expect(production_code, no_argument, [], mocked_response),
          ?assertEqual(mocked_response, production_code:no_argument())
        end
      )},
      {"respond with an exception", ?_test(
        begin
          meck:expect(production_code, no_argument, [], meck:raise(error, blah)),
          ?assertError(blah, production_code:no_argument())
        end
      )},
      {"mock function with argument", ?_test(
        begin
          meck:expect(production_code, one_argument, [
            {[1], mocked_response},
            {['_'], catch_all_mocked_response}
          ]),
          ?assertEqual(mocked_response, production_code:one_argument(1)),
          ?assertEqual(catch_all_mocked_response, production_code:one_argument("yeha"))
        end
      )}
    ]
  }.

setup() ->
  meck:new(production_code, []). %passthrough

cleanup(_Arg0) ->
  meck:unload(production_code).