defmodule SlackAPI.Web.Dialog do
  alias SlackAPI.Web

  def open(client, dialog, trigger_id),
    do: Web.post(client, "dialog.open", {:json, %{dialog: dialog, trigger_id: trigger_id}})
end
