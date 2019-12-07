defmodule InstagramForAnimals.Share.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string

    belongs_to :photo, InstagramForAnimals.Share.Photo
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :photo_id])
    |> validate_required([:content])
  end
end
