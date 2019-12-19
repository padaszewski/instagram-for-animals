defmodule InstagramForAnimalsWeb.Router do
  use InstagramForAnimalsWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :json_api do
    plug :accepts, ["json-api"]
    plug JaSerializer.Deserializer
    plug InstagramForAnimalsWeb.APIAuthPlug, otp_app: :instagram_for_animals
  end

  pipeline :json_api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: InstagramForAnimalsWeb.APIAuthErrorHandler
  end

  scope "/api", InstagramForAnimalsWeb do
    pipe_through :json_api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew

    resources "/photos", PhotoController, only: [:index, :show]
    resources "/comments", CommentController, only: [:index, :show]
  end
  # Other scopes may use custom stacks.
  scope "/api", InstagramForAnimalsWeb do
    pipe_through [:json_api, :json_api_protected]

    resources "/photos", PhotoController, only: [:index, :show, :create, :new]
    resources "/comments", CommentController, only: [:index, :show, :create]
    #     get "/projects/:slug", InstagramForAnimalsWeb.PhotoController, :show
  end
end
