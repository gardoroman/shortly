defmodule Shortly.Shortener do
  @moduledoc """
  The Shortener context.
  """

  import Ecto.Query, warn: false
  alias Shortly.Repo

  alias Shortly.Shortener.Link

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    query = from l in Link, order_by: [desc: :updated_at]

    Repo.all(query)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link("slug")
      %Link{}

      iex> get_link("bad")
      nil

  """
  def get_link(slug), do: Repo.get_by(Link, [slug: slug])

  def get_valid_url(nil), do: {:error, "Link not found."}
  def get_valid_url(url) do
    url = check_for_protocol(url)
    {:ok, url}
  end

  #-----------------------------------------------------------------
  # Check for for http or https protocol in url 
  # and prefixes "http://" if missing.
  #-----------------------------------------------------------------

  defp check_for_protocol(url) do
    reg = ~r/^https?:\/\//
    if Regex.match?(reg, url) do
      url
    else
      "http://" <> url
    end
  end

  @doc """
  Creates a link. If the slug is not provided, generate a random one

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(%{"url" => url, "slug" => ""} = attrs) do
    Map.put(attrs, "slug", generate_slug())
    |> create_link()
  end

  def create_link(attrs) do
    hostname = Application.get_env(:shortly, Shortly.Shortener)[:hostname]

    attrs = Map.put(attrs, "hostname", hostname)
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  defp generate_slug() do
    min = String.to_integer("100000", 36)
    max = String.to_integer("ZZZZZZ", 36)
  
    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
  end
end
