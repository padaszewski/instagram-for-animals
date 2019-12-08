defmodule InstagramForAnimals.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    has_many :photos, InstagramForAnimals.Share.Photo
    has_many :comments, InstagramForAnimals.Share.Comment

    timestamps()
  end
end
