defmodule SlackAPI.Web.Files do
  use SlackAPI.Web.DefMethods

  alias SlackAPI.Web.Files.Comments
  alias SlackAPI.Web.Files.Remote

  def remote,
    do: Remote

  def comments,
    do: Comments

  defpost :delete, "files.delete", ~w[file]a
  defget :info, "files.info", ~w[file]a, ~w[count cursor limit page]
  defget :list, "files.list", [], ~w[channel count page show_files_hidden_by_limit ts_from ts_to types user]
  defpost :revoke_public_url, "files.revokePublicURL", ~w[file]a
  defpost :shared_public_url, "files.sharedPublicURL", ~w[file]a
  defpost :upload, "files.upload", [], ~w[channels content file filename filetype initial_comment thread_ts title]a
end
