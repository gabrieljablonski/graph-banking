defmodule GraphBanking.Web.Router do
  use GraphBanking.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug,
      schema: GraphBanking.Web.Schema.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: GraphBanking.Web.Schema,
      interface: :simple,
      context: %{pubsub: GraphBanking.Web.Endpoint}
  end
end
