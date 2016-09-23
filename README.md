# Echobot

## Starting Server
```erlang
1> echobot:server(2000).
Listening on port 2000
```

## Interacting with Server
```shell
> {"repeat":"I'm a public message"}
I'm a public message

> {"encode":"I'm a super secret message"}
N,r%f%xzujw%xjhwjy%rjxxflj

> {"decode":"N,r%f%xzujw%xjhwjy%rjxxflj"}
I'm a super secret message
```
