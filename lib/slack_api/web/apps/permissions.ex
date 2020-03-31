defmodule SlackAPI.Web.Apps.Permissions do
  use SlackAPI.Web.DefMethods

  alias SlackAPI.Web.Apps.Permissions.Resources
  alias SlackAPI.Web.Apps.Permissions.Scopes
  alias SlackAPI.Web.Apps.Permissions.Users

  def resources,
    do: Resources

  def scopes,
    do: Scopes

  def users,
    do: Users

  defget :info, "apps.permissions.info"
  defget :request, "apps.permissions.request", ~w[scopes trigger_id]a
end
