defmodule SlackAPI.Web.Auth do
  alias SlackAPI.Web

  def revoke(client, real \\ true)
  def revoke(client, false),
    do: Web.get(client, "auth.revoke", test: "1")
  def revoke(client, _),
    do: Web.get(client, "auth.revoke")

  def test(client),
    do: Web.post(client, "auth.test", {:json, nil})
end
