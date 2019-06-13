# Banyan Api

A library for our Elixir apps to communicate with
[Banyan](https://github.com/pixelunion/banyan).

## Configuration

#### Ueberauth

The Banyan API requires [UeberAuth](https://github.com/ueberauth/ueberauth) for
handling authentication.

```elixir
config :ueberauth, Ueberauth.Strategy.Auth0.OAuth,
  app_baseurl: System.get_env("AUTH0_APP_BASEURL"),
  domain: System.get_env("AUTH0_DOMAIN"),
  client_id: System.get_env("AUTH0_CLIENT_ID"),
  client_secret: System.get_env("AUTH0_CLIENT_SECRET")
```

It also requires defining an app name (`who` or `uso`) and a GraphQL endpoint:

```elixir
config :banyan_api,
  graphql_endpoint: System.get_env("BANYAN_GRAPHQL_ENDPOINT"),
  app_name: "who"
```

#### Overriding auth0 in non-production environments

For developing locally, set an auth token fetch implementation that returns an
empty string like so:

```elixir
# dev.exs

config :banyan_api,
  access_token_impl: fn -> {:ok, ""} end
```
