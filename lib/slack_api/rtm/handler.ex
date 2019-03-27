defmodule SlackAPI.RTM.Handler do
  @callback init(data :: map, options :: list) :: {:ok, new_state :: term}
  @callback handle_connect(conn :: WebSockex.Conn.t(), state :: term) :: {:ok, new_state :: term}
  @callback handle_cast(msg :: term, state :: term) ::
    {:ok, new_state :: term}
    | {:reply, frame :: WebSockex.frame(), new_state :: term}
    | {:close, new_state :: term}
    | {:close, close_frame :: WebSockex.close_frame(), new_state :: term}

  @callback handle_info(msg :: term, state :: term) ::
    {:ok, new_state :: term}
    | {:reply, frame :: WebSockex.frame(), new_state :: term}
    | {:close, new_state :: term}
    | {:close, close_frame :: WebSockex.close_frame(), new_state :: term}

  @callback handle_message(message :: map, state :: term) ::
    {:ok, new_state :: term}
    | {:error, {:handler, binary}}
  @callback handle_disconnect(connection_status_map :: map, state :: term) ::
    {:ok, new_state :: term}
    | {:reconnect, new_state :: term}
    | {:reconnect, new_conn :: WebSockex.Conn.t(), new_state :: term}

  defmacro __using__(_opts \\ []) do
    quote location: :keep do
      @behaviour unquote(__MODULE__)

      @__error_handler__ SlackAPI.RTM.ErrorHandler

      import unquote(__MODULE__), only: [error: 1]

      @before_compile unquote(__MODULE__)

      def init(_data, _options), do: {:ok, %{}}
      def handle_connect(_conn, state), do: {:ok, state}
      def handle_message(_message, state), do: {:ok, state}
      def handle_disconnect(_map, state), do: {:ok, state}
      def handle_cast(_message, state), do: {:ok, state}
      def handle_info(_message, state), do: {:ok, state}

      defoverridable [
        init: 2,
        handle_connect: 2,
        handle_message: 2,
        handle_disconnect: 2,
        handle_cast: 2,
        handle_info: 2
      ]
    end
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      def handle_error(error) do
        @__error_handler__.handle(error)
      end
      def handle_error(exception, strace) do
        @__error_handler__.handle(exception, strace)
      end
    end
  end

  defmacro error(nil) do
    quote location: :keep do
      @__error_handler__ SlackAPI.RTM.ErrorHandler
    end
  end

  defmacro error(handler) do
    quote location: :keep do
      @__error_handler__ unquote(handler)
    end
  end
end
