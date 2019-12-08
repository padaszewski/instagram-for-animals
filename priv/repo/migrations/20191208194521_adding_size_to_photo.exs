defmodule InstagramForAnimals.Repo.Migrations.AddingSizeToPhoto do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      add :size, :bigint
    end
  end
end
