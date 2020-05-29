defmodule GraphBanking.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GraphBanking.Repo,
      # Start the Telemetry supervisor
      GraphBanking.Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GraphBanking.PubSub},
      # Start the Endpoint (http/https)
      GraphBanking.Web.Endpoint
      # Start a worker by calling: GraphBanking.Worker.start_link(arg)
      # {GraphBanking.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphBanking.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GraphBanking.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
