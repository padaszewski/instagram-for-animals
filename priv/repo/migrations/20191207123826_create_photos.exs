defmodule InstagramForAnimals.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :path, :text
      add :description, :text

      timestamps()
    end

  end
end
