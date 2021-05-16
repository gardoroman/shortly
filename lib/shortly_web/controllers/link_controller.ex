defmodule ShortlyWeb.LinkController do
  use ShortlyWeb, :controller

  alias Shortly.Shortener
  alias Shortly.Shortener.Link
  alias Shortly.Repo

  def index(conn, _params) do
    links = Shortener.list_links()
    changeset = Link.changeset(%Link{}, %{})

    render(conn, "index.html", links: links, changeset: changeset)
  end

  def new(conn, _params) do
    changeset = Shortener.change_link(%Link{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"link" => link_params}) do
    case Shortener.create_link(link_params) do
      {:ok, _link} ->
        conn
        |> put_flash(:info, "Link created successfully.")
        |> redirect(to: Routes.link_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    with(
      link <- Shortener.get_link(slug),
      {:ok, url} <- Shortener.get_valid_url(link.url)
    ) do
      redirect(conn, external: url)
    else
      {:eroor, error_info} -> 
      conn
      |> put_flash(:error, error_info)
      |> redirect(to: Routes.link_path(conn, :index))
    end
  end

  # def edit(conn, %{"id" => id}) do
  #   link = Shortener.get_link!(id)
  #   changeset = Shortener.change_link(link)
  #   render(conn, "edit.html", link: link, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "link" => link_params}) do
  #   link = Shortener.get_link!(id)

  #   case Shortener.update_link(link, link_params) do
  #     {:ok, link} ->
  #       conn
  #       |> put_flash(:info, "Link updated successfully.")
  #       |> redirect(to: Routes.link_path(conn, :show, link))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", link: link, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   link = Shortener.get_link!(id)
  #   {:ok, _link} = Shortener.delete_link(link)

  #   conn
  #   |> put_flash(:info, "Link deleted successfully.")
  #   |> redirect(to: Routes.link_path(conn, :index))
  # end
end
