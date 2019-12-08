defmodule InstagramForAnimals.Repo.Migrations.AddingFilanmeAndExtensionToPhoto do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      add :filename, :text
      add :extension, :text
    end
  end
end
