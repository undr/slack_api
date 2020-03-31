defmodule SlackAPI.Web.Apps do
  use SlackAPI.Web.DefMethods

  defget :uninstall, "apps.uninstall", ~w[client_id client_secret]a
end
