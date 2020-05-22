defmodule InstagramForAnimals.Share.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    field :username, :string

    belongs_to :photo, InstagramForAnimals.Share.Photo
    belongs_to :user, InstagramForAnimals.Users.User
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :photo_id, :user_id, :username])
    |> validate_required([:content])
  end
end
