defmodule SlackAPI.Web.Team do
  use SlackAPI.Web.DefMethods

  def profile,
    do: SlackAPI.Web.Team.Profile

  defget :access_logs, "team.accessLogs", [], ~w[before count page]a
  defget :billable_info, "team.billableInfo", [], ~w[user]a
  defget :info, "team.info", [], ~w[team]a
  defget :integration_logs, "team.integrationLogs", [], ~w[app_id change_type count page service_id user]a
end
