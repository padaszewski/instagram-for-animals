defmodule InstagramForAnimalsWeb.CommentView do
  use InstagramForAnimalsWeb, :view
  use JaSerializer.PhoenixView

  attributes [:content, :photo_id, :user_id, :username]
end
