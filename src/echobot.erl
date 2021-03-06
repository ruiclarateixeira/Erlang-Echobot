-module(echobot).
-export([server/1, receive_data/1, listen/1]).

server(Port) ->
  {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false}]),
  io:format("Listening on port ~w~n", [Port]),
  ListenerPid = spawn(echobot, listen, [ListenSocket]),
  register(listener, ListenerPid),
  case io:get_chars(">", 1) of
    eof ->
      gen_tcp:close(ListenSocket);
    {error, ErrorDescription} ->
      io:format("Error: ~p~n", [ErrorDescription]);
    Data ->
      io:format("Got data: ~p~n", [Data])
  end.

listen(ListenSocket) ->
  {ok, AcceptSocket} = gen_tcp:accept(ListenSocket),
  Pid = spawn(echobot, receive_data, [AcceptSocket]),
  io:format("Connection started pid: ~w~n", [Pid]),
  listen(ListenSocket).

receive_data(Socket) ->
  case gen_tcp:recv(Socket, 0) of
    {ok, Binary} ->
      Message = jsx:decode(Binary, [return_maps]),
      gen_tcp:send(Socket, create_response(Message)),
      receive_data(Socket);
    {error, closed} ->
      io:format("Socket closed.")
  end.

create_response(#{<<"repeat">> := Content}) ->
  Content;
create_response(#{<<"encode">> := Content}) ->
  encode:encode(binary_to_list(Content));
create_response(#{<<"decode">> := Content}) ->
  encode:decode(binary_to_list(Content));
create_response(_) ->
  io:format("Action not reconized~n").
