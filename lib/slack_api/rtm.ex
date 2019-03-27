defmodule SlackAPI.RTM do
  require Logger
  use WebSockex

  defstruct [handler: nil, state: %{}]

  def start({handler, options}) do
    {:ok, url, state} = init(handler, options)
    WebSockex.start(url, __MODULE__, struct(__MODULE__, handler: handler, state: state), [name: __MODULE__])
  end

  def start_link({handler, options}) do
    {:ok, url, state} = init(handler, options)
    WebSockex.start_link(url, __MODULE__, struct(__MODULE__, handler: handler, state: state), [name: __MODULE__])
  end

  def init(handler, options) do
    with {:ok, token} <- Keyword.fetch(options, :token),
         {:ok, data}  <- get_connection(token, options),
         {:ok, state} <- handler.init(data, options) do
      {:ok, data.url, state}
    else
      :error -> {:error, :token_not_found}
      error  -> error
    end
  end

  def handle_frame({:text, message}, state) do
    with {:ok, message} <- Poison.Parser.parse(message, keys: :atoms),
         true <- Map.has_key?(message, :type),
         {:ok, inner_state} <- handle(:message, message, state) do
      {:ok, %{state | state: inner_state}}
    else
      {:error, {:handler, error}} -> handle_error(error, state)
      _                           -> {:ok, state}
    end
  end

  def handle_connect(conn, state) do
    with {:ok, inner_state} <- handle(:connect, conn, state) do
      {:ok, %{state | state: inner_state}}
    else
      {:error, {:handler, error}} -> handle_error(error, state)
      _                           -> {:ok, state}
    end
  end

  def handle_disconnect(conn, state) do
    case handle(:disconnect, conn, state) do
      {:ok, inner_state}                  -> {:ok, %{state | state: inner_state}}
      {:reconnect, inner_state}           -> {:reconnect, %{state | state: inner_state}}
      {:reconnect, new_conn, inner_state} -> {:reconnect, new_conn, %{state | state: inner_state}}
      {:error, {:handler, error}}         -> handle_error(error, state)
      {:error, _}                         -> {:ok, state}
    end
  end

  def handle_info(message, state) do
    case handle(:info, message, state) do
      {:ok, inner_state}                 -> {:ok, %{state | state: inner_state}}
      {:reply, frame, inner_state}       -> {:reply, frame, %{state | state: inner_state}}
      {:close, inner_state}              -> {:close, %{state | state: inner_state}}
      {:close, close_frame, inner_state} -> {:close, close_frame, %{state | state: inner_state}}
      {:error, {:handler, error}}        -> handle_error(error, state)
      {:error, _}                        -> {:ok, state}
    end
  end

  def handle_cast(message, state) do
    case handle(:cast, message, state) do
      {:ok, inner_state}                 -> {:ok, %{state | state: inner_state}}
      {:reply, frame, inner_state}       -> {:reply, frame, %{state | state: inner_state}}
      {:close, inner_state}              -> {:close, %{state | state: inner_state}}
      {:close, close_frame, inner_state} -> {:close, close_frame, %{state | state: inner_state}}
      {:error, {:handler, error}}        -> handle_error(error, state)
      {:error, _}                        -> {:ok, state}
    end
  end

  defp handle(event, conn_or_message, %{handler: handler, state: state}) do
    try do
      :erlang.apply(handler, :"handle_#{event}", [conn_or_message, state])
    rescue
      e ->
        handle_exception(e, __STACKTRACE__, handler)
        {:error, {:exception, Exception.message(e)}}
    end
  end

  defp handle_error(error, %{handler: handler, state: state}) do
    handler.handle_error(error)
    {:ok, %{handler: handler, state: state}}
  end

  defp handle_exception(exception, stacktrace, handler) do
    handler.handle_error(exception, stacktrace)
    raise exception
  end

  defp get_connection(token, options) do
    url = Keyword.get(options, :url, "https://slack.com")
    client = SlackAPI.Web.new(token: token, url: url)

    case SlackAPI.Web.rtm().start(client, no_latest: true) do
      %{ok: false, error: error} -> {:error, {:web_api, error}}
      data                       -> {:ok, data}
    end
  end
end
