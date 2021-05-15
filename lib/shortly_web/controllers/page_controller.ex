defmodule ShortlyWeb.PageController do
  use ShortlyWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.link_path(conn, :index))
  end
end
