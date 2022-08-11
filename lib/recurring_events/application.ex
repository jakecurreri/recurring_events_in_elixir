defmodule RecurringEvents.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      RecurringEvents.Repo,
      # Start the Telemetry supervisor
      RecurringEventsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RecurringEvents.PubSub},
      # Start the Endpoint (http/https)
      RecurringEventsWeb.Endpoint
      # Start a worker by calling: RecurringEvents.Worker.start_link(arg)
      # {RecurringEvents.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RecurringEvents.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RecurringEventsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
