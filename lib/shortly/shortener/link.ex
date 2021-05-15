defmodule Shortly.Shortener.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :slug, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :slug])
    |> validate_required([:url, :slug])
    |> unique_constraint(:slug)
  end
end
