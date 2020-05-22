defmodule InstagramForAnimals.Repo.Migrations.AddUsernameToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :username, :text
    end
  end
end
