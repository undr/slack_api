defmodule SlackAPI.Web.Auth do
  use SlackAPI.Web.DefMethods

  defget :revoke, "auth.revoke", [], ~w[test]a
  defpost :test, "auth.test"
end
