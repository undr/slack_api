defmodule SlackAPI.Web.Team.Profile do
  use SlackAPI.Web.DefMethods

  defget :get, "team.profile.get", [], ~w[visibility]a
end
