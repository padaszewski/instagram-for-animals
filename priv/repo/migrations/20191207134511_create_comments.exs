defmodule InstagramForAnimals.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :photo_id, references(:photos)
      add :content, :text
      timestamps()
    end

  end
end
