defmodule SlackAPI.Web.Users do
  use SlackAPI.Web.DefMethods

  defget :conversations, "users.conversations", [], ~w[cursor exclude_archived limit types user]a
  defget :delete_photo, "users.deletePhoto"
  defget :get_presence, "users.getPresence", ~w[user]a
  defget :identity, "users.identity"
  defget :info, "users.info", ~w[user]a, ~w[include_locale]a
  defget :list, "users.list", [], ~w[cursor include_locale limit]a
  defget :lookup_by_email, "users.lookupByEmail", ~w[email]a
  defpost :set_active, "users.setActive"
  defget :set_photo, "users.setPhoto", ~w[image]a, ~w[crop_w crop_x crop_y]a
  defget :set_presence, "users.setPresence", ~w[presence]a
end
