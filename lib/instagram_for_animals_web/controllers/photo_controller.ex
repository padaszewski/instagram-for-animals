defmodule InstagramForAnimalsWeb.PhotoController do
  use InstagramForAnimalsWeb, :controller

  alias InstagramForAnimals.Share
  alias InstagramForAnimals.Share.Photo

  action_fallback InstagramForAnimalsWeb.FallbackController

  def index(conn, _params) do
    photos = Share.list_photos()
    render(conn, "index.json-api", data: photos)
  end

  def create(conn, %{"photo" => photo_params}) do
    IO.inspect conn.assigns.current_user.id
    if upload = photo_params["file"] do
      IO.inspect("im here")
      extension = Path.extname(upload.filename)
      project_root = File.cwd!
      current_time = :os.system_time(:millisecond)
      var = File.cp(upload.path, "#{project_root}/media/#{current_time}#{extension}")
    end
    with {:ok, %Photo{} = photo} <- Share.create_photo(photo_params) do
      conn
                 |> put_status(:created)
                 |> put_resp_header("location", Routes.photo_path(conn, :show, photo))
                 |> render("show.json-api", data: photo)
    end
  end

  def show(conn, %{"id" => id}) do
    photo = Share.get_photo!(id)
    render(conn, "show.json-api", data: photo)
  end

  def update(conn, %{"id" => id, "photo" => photo_params}) do
    photo = Share.get_photo!(id)

    with {:ok, %Photo{} = photo} <- Share.update_photo(photo, photo_params) do
      render(conn, "show.json-api", data: photo)
    end
  end

  def delete(conn, %{"id" => id}) do
    photo = Share.get_photo!(id)

    with {:ok, %Photo{}} <- Share.delete_photo(photo) do
      send_resp(conn, :no_content, "")
    end
  end
end
