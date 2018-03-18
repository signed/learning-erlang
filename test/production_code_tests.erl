-module(production_code_tests).

-include_lib("eunit/include/eunit.hrl").

stubbing_modules_and_functions_test_() ->
  {foreach,
    fun setup/0,
    fun cleanup/1,
    [
      {"with no argument", ?_test(
        begin
          meck:expect(production_code, no_argument, [], mocked_response),
          ?assertEqual(mocked_response, production_code:no_argument())
        end
      )},
      {"with argument", ?_test(
        begin
          meck:expect(production_code, one_argument, [
            {[1], mocked_response},
            {['_'], catch_all_mocked_response}
          ]),
          ?assertEqual(mocked_response, production_code:one_argument(1)),
          ?assertEqual(catch_all_mocked_response, production_code:one_argument("yeha"))
        end
      )},
      {"can be check if they have been called", ?_test(
        begin
          meck:expect(production_code, no_argument, [], do_not_care),
          production_code:no_argument(),
          ?assert(meck:called(production_code, no_argument, []))
        end
      )},
      {"can be check if they have been called even based on arguments", ?_test(
        begin
          OldEnough = fun(Age) -> Age > 18 end,
          meck:expect(production_code, one_argument, ['_'], do_not_care),
          production_code:one_argument(45),
          ?assert(meck:called(production_code, one_argument, [meck:is(OldEnough)]))
        end
      )},
      {"call history for a module can be reset", ?_test(
        begin
          meck:expect(production_code, one_argument, ['_'], do_not_care),
          production_code:one_argument(-37),
          ?assert(meck:called(production_code, one_argument, ['_'])),
          meck:reset(production_code),
          ?assert(not meck:called(production_code, one_argument, ['_']))
        end
      )}
    ]
  }.



mock_response_test_() ->
  {foreach,
    fun setup/0,
    fun cleanup/1,
    [
      {"constant value", ?_test(
        begin
          meck:expect(production_code, no_argument, [], meck:val(just_the_val)),
          ?assertEqual(just_the_val, production_code:no_argument())
        end
      )},
      {"an exception", ?_test(
        begin
          meck:expect(production_code, no_argument, [], meck:raise(error, blah)),
          ?assertError(blah, production_code:no_argument())
        end
      )},
      {"based on the arguments", ?_test(
        begin
          meck:expect(production_code, one_argument, ['_'], meck:exec(fun(A) -> A + 1 end)),
          %meck:expect(production_code, one_argument, ['_'], fun(A) -> A + 1 end),
          ?assertEqual(42, production_code:one_argument(41))
        end
      )},
      {"with the production code result", ?_test(
        begin
          meck:expect(production_code, no_argument, [], meck:passthrough()),
          ?assertEqual(the_real_thing, production_code:no_argument())
        end
      )},
      {"value from a sequence", ?_test(
        begin
          meck:expect(production_code, no_argument, [], meck:seq([one, two, three])),
          ?assertEqual(one, production_code:no_argument()),
          ?assertEqual(two, production_code:no_argument()),
          ?assertEqual(three, production_code:no_argument()),
          ?assertEqual(three, production_code:no_argument()),
          ?assertEqual(three, production_code:no_argument())
        end
      )},
      {"value from a looped sequence", ?_test(
        begin
          meck:expect(production_code, no_argument, [], meck:loop([one, two])),
          ?assertEqual(one, production_code:no_argument()),
          ?assertEqual(two, production_code:no_argument()),
          ?assertEqual(one, production_code:no_argument()),
          ?assertEqual(two, production_code:no_argument()),
          ?assertEqual(one, production_code:no_argument())
        end
      )}
    ]
  }.

capture_argument_test_() ->
  {foreach,
    fun setup/0,
    fun cleanup/1,
    [
      {"handed to the function", ?_test(
        begin
          meck:expect(production_code, one_argument, ['_'], do_not_care),
          RandomValue = rand:uniform(1000),
          production_code:one_argument(RandomValue),
          Captured = meck:capture(first, production_code, one_argument, ['_'], 1),
          ?assertEqual(Captured, RandomValue)
        end
      )},
      {"with multiple arguments handed to the function", ?_test(
        begin
          meck:expect(production_code, two_arguments, ['_', '_'], do_not_care),
          RandomValue = rand:uniform(1000),
          production_code:two_arguments(one, nope),
          production_code:two_arguments(two, nope),
          production_code:two_arguments(three, RandomValue),
          Captured = meck:capture(first, production_code, two_arguments, [three, '_' ], 2),
          ?assertEqual(Captured, RandomValue)
        end
      )}
    ]
  }.


setup() ->
  meck:new(production_code, []). %passthrough, stub_all,

cleanup(_Arg0) ->
  meck:unload().