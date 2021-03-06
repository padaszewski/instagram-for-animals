defmodule InstagramForAnimalsWeb.CommentController do
  use InstagramForAnimalsWeb, :controller

  alias InstagramForAnimals.Share
  alias InstagramForAnimals.Share.Comment

  action_fallback InstagramForAnimalsWeb.FallbackController

  def index(conn, _params) do
    comments = Share.list_comments()
    render(conn, "index.json-api", data: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    comment_params =
      comment_params
      |> Map.put("user_id", conn.assigns.current_user.id)
      |> Map.put("username", conn.assigns.current_user.email)
    with {:ok, %Comment{} = comment} <- Share.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.comment_path(conn, :show, comment))
      |> render("show.json-api", data: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Share.get_comment!(id)
    render(conn, "show.json-api", data: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Share.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Share.update_comment(comment, comment_params) do
      render(conn, "show.json-api", data: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Share.get_comment!(id)

    with {:ok, %Comment{}} <- Share.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
