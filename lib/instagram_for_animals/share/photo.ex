defmodule InstagramForAnimals.Share.Photo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "photos" do
    field :description, :string
    field :path, :string
    field :filename, :string
    field :size, :integer
    field :content_type, :string
    field :extension, :string
    field :public, :boolean
    field :username, :string

    belongs_to :user, InstagramForAnimals.Users.User
    has_many :comments, InstagramForAnimals.Share.Comment

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:path, :description, :user_id, :size, :content_type, :extension, :filename, :public, :username])
    |> validate_required([:description, :user_id, :public])
    |> validate_number(:size, greater_than: 0, message: "Please provide a file.")
    |> validate_inclusion(:content_type, ["image/jpeg", "image/jpg", "image/bmp", "image/png"], message: "Please provide a valid file with one of following formats: jpeg, jpg, bmp, png.")
  end
end
