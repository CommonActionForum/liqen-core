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

    resources "/users", UserController, only: [:create, :show]
    resources "/sessions", SessionController, only: [:create, :delete]
    resources "/tags", TagController, except: [:new, :edit]
    resources "/articles", ArticleController, except: [:new, :edit]
    resources "/annotations", AnnotationController, except: [:new, :edit]
    resources "/questions", QuestionController, except: [:new, :edit]
    resources "/liqens", FactController, except: [:new, :edit]
    resources "/concepts", ConceptController, except: [:new, :edit]

    #    scope "/v3", V3, as: :v3 do
    #      resources "/annotations", TagController, except: [:new, :edit]
    #      resources "/articles", TagController, except: [:new, :edit]
    #      resources "/liqens", TagController, except: [:new, :edit]
    #      resources "/questions", TagController, except: [:new, :edit]
    #      resources "/tags", TagController, except: [:new, :edit]
    #      resources "/users", UserController, only: [:create, :show]
    #
    #      resources "/sessions", SessionController, only: [:create, :delete]
    #    end

    get "/private", PrivateController, :example
  end

  # Other scopes may use custom stacks.
  # scope "/api", Core do
  #   pipe_through :api
  # end
end
