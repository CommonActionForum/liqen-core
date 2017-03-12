defmodule Core.Router do
  use Core.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Core.Auth, repo: Core.Repo
  end

  scope "/", Core do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, only: [:create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Core do
  #   pipe_through :api
  # end
end
