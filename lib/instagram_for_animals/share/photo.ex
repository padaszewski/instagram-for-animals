defmodule InstagramForAnimals.Share.Photo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "photos" do
    field :description, :string
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:path, :description])
    |> validate_required([:path, :description])
  end
end
