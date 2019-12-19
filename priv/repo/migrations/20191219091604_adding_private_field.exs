defmodule InstagramForAnimals.Repo.Migrations.AddingPrivateField do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      add :public, :bool
    end
  end
end
