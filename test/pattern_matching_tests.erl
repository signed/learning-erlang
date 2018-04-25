-module(pattern_matching_tests).

-include_lib("eunit/include/eunit.hrl").

name_this_differently_test_() ->
  {foreach,
    fun setup2/0,
    fun cleanup2/1,
    [
      {"with no argument", ?_test(
        begin
          ?assertEqual(<<"the true one">>, pattern_matching:one(blub, true, ban))
        end
      )},
      {"with argument", ?_test(
        begin
          ?assertEqual(<<"the true one">>, pattern_matching:one(blub, [true, ban]))
        end
      )}
    ]
  }.

setup2() ->
  ok.

cleanup2(_Arg0) ->
  ok.