defmodule SlackAPI.Web.API do
  use SlackAPI.Web.DefMethods

  defpost :test, "api.test", [], ~w[error foo]a
end
