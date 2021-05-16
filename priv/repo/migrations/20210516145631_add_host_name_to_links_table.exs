defmodule Shortly.Repo.Migrations.AddHostNameToLinksTable do
  use Ecto.Migration

  def change do
    alter table(:links), do: add :hostname, :string
  end
end
