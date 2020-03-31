defmodule SlackAPI.Web.Oauth.V2 do
  use SlackAPI.Web.DefMethods

  defpost :access, "oauth.v2.access", ~w[code]a, ~w[client_id client_secret redirect_uri]a
end
