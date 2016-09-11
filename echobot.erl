-module(echobot).
-export([server/1, receive_data/1]).

server(Port) ->
  {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false}]),
  io:format("Listening on port ~w~n", [Port]),
  listen(ListenSocket),
  gen_tcp:close(ListenSocket).

listen(ListenSocket) ->
  {ok, AcceptSocket} = gen_tcp:accept(ListenSocket),
  Pid = spawn(echobot, receive_data, [AcceptSocket]),
  io:format("Connection started pid: ~w~n", [Pid]),
  listen(ListenSocket).

receive_data(Socket) ->
  case gen_tcp:recv(Socket, 0) of
    {ok, Binary} ->
      gen_tcp:send(Socket, binary_to_list(Binary)),
      receive_data(Socket);
    {error, closed} ->
      io:format("Socket closed.")
  end.
