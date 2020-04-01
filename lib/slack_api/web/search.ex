defmodule SlackAPI.Web.Search do
  use SlackAPI.Web.DefMethods

  defget :all, "search.all", ~w[query]a, ~w[count highlight page sort sort_dir]a
  defget :files, "search.files", ~w[query]a, ~w[count highlight page sort sort_dir]a
  defget :messages, "search.messages", ~w[query]a, ~w[count highlight page sort sort_dir]a
end
