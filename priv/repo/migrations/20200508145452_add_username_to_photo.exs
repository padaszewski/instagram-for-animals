defmodule InstagramForAnimals.Repo.Migrations.AddUsernameToPhoto do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      add :username, :text
    end
  end
end
