defmodule InstagramForAnimals.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do

      timestamps()
    end

  end
end
