defmodule SlackAPI.Web.Oauth do
  use SlackAPI.Web.DefMethods

  defpost :access, "oauth.access", ~w[client_id client_secret code]a, ~w[redirect_uri single_channel]a
  defpost :token, "oauth.token", ~w[client_id client_secret code]a, ~w[redirect_uri single_channel]a
end
