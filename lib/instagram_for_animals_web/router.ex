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

  # Other scopes may use custom stacks.
   scope "/api", InstagramForAnimalsWeb do
     pipe_through :api

     resources "/Photos", PhotoController, only: [:index, :show]
#     get "/projects/:slug", InstagramForAnimalsWeb.PhotoController, :show
   end
end
