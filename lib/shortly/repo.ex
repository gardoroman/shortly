defmodule Shortly.Repo do
  use Ecto.Repo,
    otp_app: :shortly,
    adapter: Ecto.Adapters.Postgres
end
