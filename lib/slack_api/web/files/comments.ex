defmodule SlackAPI.Web.Files.Comments do
  use SlackAPI.Web.DefMethods

  defpost :delete, "files.comments.delete", ~w[file id]a
end
