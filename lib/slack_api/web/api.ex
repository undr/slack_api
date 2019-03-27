defmodule SlackAPI.Web.API do
  alias SlackAPI.Web

  def test(client, params \\ %{}),
    do: Web.post(client, "api.test", {:json, params})
end
