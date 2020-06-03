defmodule GraphBanking.Test.Support.Web.AbsintheUtils do
  def build_query(query, query_name) do
    %{
      "operationName" => query_name,
      "query" => "query #{query_name} #{query}",
      "variables" => "{}"
    }
  end

  def build_mutation(mutation) do
    %{
      "operation_name" => "",
      "query" => mutation,
      "variables" => "{}"
    }
  end
end
