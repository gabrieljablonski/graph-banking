defmodule GraphBanking.Utils do
  import Ecto.UUID, only: [cast: 1]

  def validate_uuid(id) do
    case cast(id) do
      :error -> {:invalid_uuid, "invalid uuid #{id}"}
      {:ok, _} -> :ok
    end
  end
end
