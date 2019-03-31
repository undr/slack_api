defmodule SlackAPI.Web.IM do
  use SlackAPI.Web.DefMethods

  defpost :close, "im.close", ~w[channel]a
  defget :history, "im.history", ~w[channel]a, ~w[count inclusive latest oldest unreads]a
  defget :list, "im.list", [], ~w[cursor limit]a
  defpost :mark, "im.mark", ~w[channel ts]a
  defpost :open, "im.open", ~w[user]a, ~w[include_locale return_im]a
  defget :replies, "im.replies", ~w[channel thread_ts]a
end
