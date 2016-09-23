-module(encode).

-export([encode/1, decode/1]).

-define(INCREMENT, 5).

encode(Word) ->
  shift(increment, Word).

decode(Word) ->
  shift(decrement, Word).

shift(_, []) ->
  [];
shift(increment, [Element | Rest]) ->
  [Element + ?INCREMENT] ++ shift(increment, Rest);
shift(decrement, [Element | Rest]) ->
  [Element - ?INCREMENT] ++ shift(decrement, Rest).
