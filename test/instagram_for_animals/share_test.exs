defmodule InstagramForAnimals.ShareTest do
  use InstagramForAnimals.DataCase

  alias InstagramForAnimals.Share

  describe "photos" do
    alias InstagramForAnimals.Share.Photo

    @valid_attrs %{description: "some description", path: "some path"}
    @update_attrs %{description: "some updated description", path: "some updated path"}
    @invalid_attrs %{description: nil, path: nil}

    def photo_fixture(attrs \\ %{}) do
      {:ok, photo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Share.create_photo()

      photo
    end

    test "list_photos/0 returns all photos" do
      photo = photo_fixture()
      assert Share.list_photos() == [photo]
    end

    test "get_photo!/1 returns the photo with given id" do
      photo = photo_fixture()
      assert Share.get_photo!(photo.id) == photo
    end

    test "create_photo/1 with valid data creates a photo" do
      assert {:ok, %Photo{} = photo} = Share.create_photo(@valid_attrs)
      assert photo.description == "some description"
      assert photo.path == "some path"
    end

    test "create_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Share.create_photo(@invalid_attrs)
    end

    test "update_photo/2 with valid data updates the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{} = photo} = Share.update_photo(photo, @update_attrs)
      assert photo.description == "some updated description"
      assert photo.path == "some updated path"
    end

    test "update_photo/2 with invalid data returns error changeset" do
      photo = photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Share.update_photo(photo, @invalid_attrs)
      assert photo == Share.get_photo!(photo.id)
    end

    test "delete_photo/1 deletes the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{}} = Share.delete_photo(photo)
      assert_raise Ecto.NoResultsError, fn -> Share.get_photo!(photo.id) end
    end

    test "change_photo/1 returns a photo changeset" do
      photo = photo_fixture()
      assert %Ecto.Changeset{} = Share.change_photo(photo)
    end
  end
end
