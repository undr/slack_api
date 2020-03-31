defmodule SlackAPI.Web.Users.Profile do
  use SlackAPI.Web.DefMethods

  defget :get, "users.profile.get", [], ~w[include_labels user]a
  defpost :set, "users.profile.set", [], ~w[name profile user value]a
end
