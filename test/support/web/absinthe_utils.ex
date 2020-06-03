defmodule GraphBanking.Test.Support.Web.AbsintheUtils do
  def build_query(query) do
    %{
      "operationName" => "",
      "query" => "query #{query}",
      "variables" => "{}"
    }
  end

  def build_mutation(query) do
    %{
      "operation_name" => "",
      "query" => "mutation #{query}",
      "variables" => "{}"
    }
  end
end
