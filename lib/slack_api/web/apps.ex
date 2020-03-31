defmodule SlackAPI.Web.Apps do
  use SlackAPI.Web.DefMethods

  alias SlackAPI.Web.Apps.Permissions

  def permissions,
    do: Permissions

  defget :uninstall, "apps.uninstall", ~w[client_id client_secret]a
end
