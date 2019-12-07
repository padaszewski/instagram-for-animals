defmodule InstagramForAnimalsWeb.PhotoView do
  use InstagramForAnimalsWeb, :view
  use JaSerializer.PhoenixView

  attributes [:path, :description]

end
