defmodule SlackAPI.Web.Files.Remote do
  use SlackAPI.Web.DefMethods

  defpost :add, "files.remote.add", ~w[external_id external_url title]a, ~w[filetype indexable_file_contents preview_image]a
  defget :info, "files.remote.info", [], ~w[external_id file]a
  defget :list, "files.remote.list", [], ~w[channel cursor limit ts_from ts_to]a
  defget :remove, "files.remote.remove", [], ~w[external_id file]a
  defget :share, "files.remote.share", ~w[channels], ~w[external_id file]a
  defget :update, "files.remote.update", [], ~w[external_id external_url file filetype indexable_file_contents preview_image title]a
end
