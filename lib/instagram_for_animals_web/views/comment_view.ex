defmodule InstagramForAnimalsWeb.CommentView do
  use InstagramForAnimalsWeb, :view
  use JaSerializer.PhoenixView

  attributes [:content, :photo_id]
end
