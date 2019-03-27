defmodule SlackAPI.Web.Oauth do
  alias SlackAPI.Web

  def access(client, client_id, client_secret, code, params \\ %{})
  def access(client, client_id, client_secret, code, params) when is_list(params),
    do: access(client, client_id, client_secret, code, Enum.into(params, %{}))
  def access(client, client_id, client_secret, code, params) do
    params = Map.merge(params, %{client_id: client_id, client_secret: client_secret, code: code})
    Web.post(client, "oauth.access", {:json, params})
  end

  # Deprecated
  def token(client, client_id, client_secret, code, params \\ %{})
  def token(client, client_id, client_secret, code, params) when is_list(params),
    do: token(client, client_id, client_secret, code, Enum.into(params, %{}))
  def token(client, client_id, client_secret, code, params) do
    params = Map.merge(params, %{client_id: client_id, client_secret: client_secret, code: code})
    Web.post(client, "oauth.token", {:json, params})
  end
end
