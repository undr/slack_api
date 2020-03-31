defmodule SlackAPI.Web.Apps.Permissions.Resources do
  use SlackAPI.Web.DefMethods

  defget :list, "apps.permissions.resources.list", [], ~w[cursor limit]a
end
