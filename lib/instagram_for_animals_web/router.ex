defmodule InstagramForAnimalsWeb.Router do
  use InstagramForAnimalsWeb, :router

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
  end

  # Other scopes may use custom stacks.
   scope "/api", InstagramForAnimalsWeb do
     pipe_through :json_api

     resources "/photos", PhotoController, only: [:index, :show, :create, :new]
     resources "/comments", CommentController, only: [:index, :show, :create]
#     get "/projects/:slug", InstagramForAnimalsWeb.PhotoController, :show
   end
end
