defmodule SlackAPI.Web do
  defstruct [token: nil, url: nil]

  def api,
    do: SlackAPI.Web.API

  def auth,
    do: SlackAPI.Web.Auth

  def bots,
    do: SlackAPI.Web.Bots

  def channels,
    do: SlackAPI.Web.Channels

  def chat,
    do: SlackAPI.Web.Chat

  def conversations,
    do: SlackAPI.Web.Conversations

  def dialog,
    do: SlackAPI.Web.Dialog

  def groups,
    do: SlackAPI.Web.Groups

  def oauth,
    do: SlackAPI.Web.Oauth

  def rtm,
    do: SlackAPI.Web.RTM

  def new(opts \\ []),
    do: struct(__MODULE__, Keyword.merge(default_options(), opts))

  def get_token(%__MODULE__{token: token}),
    do: token

  def get_url(%__MODULE__{url: url}, action),
    do: "#{url}/api/#{action}"

  def post(client, action),
    do: post(client, action, {:json, ""})
  def post(client, action, {type, params}) do
    headers = headers(client, type)
    body = body(client, type, params)

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

  defp body(_, _, nil),
    do: ""
  defp body(_, :json, params),
    do: params |> normalize_params() |> Poison.encode!()
  defp body(client, :form, params),
    do: {:form, query(client, params)}

  defp query(_, nil),
    do: ""
  defp query(client, params) do
    params
    |> normalize_params()
    |> Map.put(:token, get_token(client))
  end

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

  defp normalize_params(params) when is_list(params),
    do: Enum.into(params, %{})
  defp normalize_params(params),
    do: params

  defp default_options do
    [token: Application.get_env(:slack_api, :api_token), url: Application.get_env(:slack_api, :url)]
  end
end
