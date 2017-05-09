# Official Elixir image as base
FROM elixir:1.4

WORKDIR /app

ADD . /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

EXPOSE 80
CMD mix phoenix.server
