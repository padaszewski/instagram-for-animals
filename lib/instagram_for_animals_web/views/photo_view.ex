defmodule InstagramForAnimalsWeb.PhotoView do
  use InstagramForAnimalsWeb, :view
  use JaSerializer.PhoenixView

  attributes [:path, :description, :user_id, :size, :content_type]

end
