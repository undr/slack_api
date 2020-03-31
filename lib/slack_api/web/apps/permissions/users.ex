defmodule SlackAPI.Web.Apps.Permissions.Users do
  use SlackAPI.Web.DefMethods

  defget :list, "apps.permissions.users.list", [], ~w[cursor limit]a
  defget :request, "apps.permissions.users.request", ~w[scopes trigger_id user]
end
