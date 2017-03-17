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
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", Core do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, only: [:create, :delete]
    resources "/tags", TagController, except: [:new, :edit]
    resources "/articles", ArticleController, except: [:new, :edit]
    resources "/annotations", AnnotationController, except: [:new, :edit] do
      resources "/tags", AnnotationTagController, only: [:create, :delete]
    end
    resources "/questions", QuestionController, except: [:new, :edit] do
      resources "/tags", QuestionTagController, only: [:create, :delete]
    end
    resources "/facts", FactController, except: [:new, :edit] do
      resources "/annotations", FactAnnotationController, only: [:create, :delete]
    end

    get "/private", PrivateController, :example
  end

  # Other scopes may use custom stacks.
  # scope "/api", Core do
  #   pipe_through :api
  # end
end
