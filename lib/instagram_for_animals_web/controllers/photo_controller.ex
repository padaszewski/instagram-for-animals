defmodule InstagramForAnimalsWeb.PhotoController do
  use InstagramForAnimalsWeb, :controller

  alias InstagramForAnimals.Share
  alias InstagramForAnimals.Share.Photo

  action_fallback InstagramForAnimalsWeb.FallbackController

  def index(conn, _params) do
    IO.inspect conn
    photos = case conn.assigns.current_user do
      nil -> Share.list_public_photos()
      _ -> Share.list_public_photos_with_user_privates(conn.assigns.current_user.id)
    end

    photos = case _params["user"] do
      nil -> photos
      _ -> Share.list_users_public_photos(_params["user"])
    end



    render(conn, "index.json-api", data: photos)
  end

  def create(conn, %{"photo" => photo_params}) do
    photo_params = Map.put(photo_params, "user_id", conn.assigns.current_user.id)

    changes =
      if upload = photo_params["file"] do
        content_type = upload.content_type
        size = File.stat!(upload.path).size
        extension = Path.extname(upload.filename)
        project_root = File.cwd!
        filename = :os.system_time(:millisecond)
        static_path = "/priv/static"
        relative_path = "/images/media/user-id-#{conn.assigns.current_user.id}"
        save_path = "#{static_path}#{relative_path}"
        case File.exists?("#{project_root}#{save_path}") do
          false -> File.mkdir_p!("#{project_root}/#{save_path}")
          _ -> IO.inspect "Directory exists already."
        end
        copy_path = "#{save_path}/#{filename}#{extension}"
        save_path = "#{relative_path}/#{filename}#{extension}"
        case extension do
          ".jpg" -> File.cp(upload.path, "#{project_root}#{copy_path}")
          ".png" -> File.cp(upload.path, "#{project_root}#{copy_path}")
          ".jpeg" -> File.cp(upload.path, "#{project_root}#{copy_path}")
          ".bmp" -> File.cp(upload.path, "#{project_root}#{copy_path}")
          _ -> IO.inspect "Unsupported extension!"
        end

        %{content_type: content_type, size: size, path: save_path, extension: extension, filename: filename}
      end

    changes =
      case changes do
        nil -> %{content_type: "invalid", size: "0", path: "", filename: "", extension: ""}
        _ -> changes
      end

    photo_params =
      photo_params
      |> Map.put("content_type", changes.content_type)
      |> Map.put("size", changes.size)
      |> Map.put("path", changes.path)
      |> Map.put("extension", changes.extension)
      |> Map.put("filename", "#{changes.filename}")
      |> Map.put("username", conn.assigns.current_user.email)


    with {:ok, %Photo{} = photo} <- Share.create_photo(photo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.photo_path(conn, :show, photo))
      |> render("show.json-api", data: photo)
    end
  end

  def show(conn, %{"id" => id}) do
    IO.inspect conn
    photo = Share.get_photo!(id)
    if photo.public == false do
      current_user = conn.assigns.current_user
      photo_user_id = photo.user_id
      current_user_id = if current_user != nil do
        current_user.id
      end
      case current_user_id do
        nil -> InstagramForAnimalsWeb.APIAuthErrorHandler.call(conn, :not_authenticated)
        current_user_id -> render(conn, "show.json-api", data: photo)
        _ -> InstagramForAnimalsWeb.APIAuthErrorHandler.call(conn, :not_authenticated)
      end
    else
      render(conn, "show.json-api", data: photo)
    end
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
