defmodule SlackAPI.Web.Usergroups do
  use SlackAPI.Web.DefMethods

  def users,
    do: SlackAPI.Web.Usergroups.Users

  defpost :create, "usergroups.create", ~w[name]a, ~w[channels description handle include_count]a
  defpost :disable, "usergroups.disable", ~w[usergroup]a, ~w[include_count]a
  defpost :enable, "usergroups.enable", ~w[usergroup]a, ~w[include_count]a
  defget :list, "usergroups.list", [], ~w[include_count include_disabled include_users]a
  defpost :update, "usergroups.update", ~w[usergroup]a, ~w[channels description handle include_count name]a
end
