defmodule SlackAPI.Web.DnD do
  use SlackAPI.Web.DefMethods

  defpost :end_dnd, "dnd.endDnd"
  defpost :end_snooze, "dnd.endSnooze"
  defget :info, "dnd.info", [], ~w[user]a
  defget :set_snooze, "dnd.setSnooze", ~w[num_minutes]a
  defget :team_info, "dnd.teamInfo", ~w[users]a
end
