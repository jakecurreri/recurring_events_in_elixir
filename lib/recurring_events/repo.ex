defmodule RecurringEvents.Repo do
  use Ecto.Repo,
    otp_app: :recurring_events,
    adapter: Ecto.Adapters.Postgres
end
