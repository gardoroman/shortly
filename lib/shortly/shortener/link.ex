defmodule Shortly.Shortener.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :slug, :string
    field :url, :string
    field :hostname, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :slug, :hostname])
    |> validate_required([:url, :slug, :hostname])
    |> unique_constraint(:slug)
    |> validate_length(:slug, min: 4)
  end
end
