defmodule SlackAPI.Web.Usergroups.Users do
  use SlackAPI.Web.DefMethods

  defget :list, "usergroups.users.list", ~w[usergroup]a, ~w[include_disabled]a
  defpost :update, "usergroups.users.update", ~w[usergroup users]a, ~w[include_count]a
end
