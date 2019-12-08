defmodule InstagramForAnimals.Repo.Migrations.AddingContentTypeToPhoto do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      add :content_type, :text
    end
  end
end
