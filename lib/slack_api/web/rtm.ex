defmodule SlackAPI.Web.RTM do
  use SlackAPI.Web.DefMethods

  defget :connect, "rtm.connect", [], ~w[batch_presence_aware presence_sub]a
  defget :start, "rtm.start", [],
    ~w[batch_presence_aware presence_sub mpim_aware no_latest no_unreads presence_sub simple_latest]a
end
