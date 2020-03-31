defmodule SlackAPI.Web do
  defstruct [token: nil, url: nil]

  def api,
    do: SlackAPI.Web.API

  def apps,
    do: SlackAPI.Web.Apps

  def auth,
    do: SlackAPI.Web.Auth

  def bots,
    do: SlackAPI.Web.Bots

  def chat,
    do: SlackAPI.Web.Chat

  def conversations,
    do: SlackAPI.Web.Conversations

  def dialog,
    do: SlackAPI.Web.Dialog

  def dnd,
    do: SlackAPI.Web.DnD

  def emoji,
    do: SlackAPI.Web.Emoji

  def files,
    do: SlackAPI.Web.Files

  def migration,
    do: SlackAPI.Web.Migration

  def oauth,
    do: SlackAPI.Web.Oauth

  def rtm,
    do: SlackAPI.Web.RTM

  def users,
    do: SlackAPI.Web.Users

  def new(opts \\ []),
    do: struct(__MODULE__, Keyword.merge(default_options(), opts))

  def get_token(%__MODULE__{token: token}),
    do: token

  def get_url(%__MODULE__{url: url}, action),
    do: "#{url}/api/#{action}"

  def post(client, action, params \\ "") do
    headers = headers(client, :json)
    body = body(client, params)

    client
    |> get_url(action)
    |> HTTPoison.post!(body, headers)
    |> Map.fetch!(:body)
    |> Poison.Parser.parse!(keys: :atoms)
  end

  def get(client, action, params \\ []) do
    headers = headers(client, :form)
    query = query(client, params)

    client
    |> get_url(action)
    |> HTTPoison.get!(headers, params: query)
    |> Map.fetch!(:body)
    |> Poison.Parser.parse!(keys: :atoms)
  end

  defp body(_, ""),
    do: ""
  defp body(_, params),
    do: params |> Enum.into(%{}) |> Poison.encode!()

  defp query(client, params),
    do: params |> Enum.into([]) |> Keyword.put(:token, get_token(client))

  defp headers(_client, :form),
    do: [{"Accept", "application/json;charset=utf-8"}]
  defp headers(client, :json) do
    [
      {"Content-Type", "application/json;charset=utf-8"},
      {"Accept", "application/json;charset=utf-8"},
      authorization(client)
    ]
  end

  defp authorization(client) do
    {"Authorization", "Bearer #{ get_token(client)}"}
  end

  defp default_options do
    [token: Application.get_env(:slack_api, :api_token), url: Application.get_env(:slack_api, :url)]
  end
end
