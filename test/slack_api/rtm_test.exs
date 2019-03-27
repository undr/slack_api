defmodule SlackAPI.RTMTest do
  use ExUnit.Case

  import Mox

  alias SlackAPI.RTM
  alias SlackAPI.RTM.MockHandler
  alias SlackAPI.RTM.MockErrorHandler

  defmodule TestHandlerWithError do
    use SlackAPI.RTM.Handler
    error MockErrorHandler

    def handle_message(_message, _state), do: {:error, {:handler, "error"}}
    def handle_connect(_conn, _state), do: {:error, {:handler, "error"}}
    def handle_disconnect(_conn, _state), do: {:error, {:handler, "error"}}
    def handle_cast(_conn, _state), do: {:error, {:handler, "error"}}
    def handle_info(_conn, _state), do: {:error, {:handler, "error"}}
  end

  defmodule TestHandlerWithException do
    use SlackAPI.RTM.Handler
    error MockErrorHandler

    def handle_message(_message, _state), do: raise "error"
    def handle_connect(_conn, _state), do: raise "error"
    def handle_disconnect(_conn, _state), do: raise "error"
    def handle_cast(_conn, _state), do: raise "error"
    def handle_info(_conn, _state), do: raise "error"
  end

  setup context do
    do_setup(context)
    :ok
  end

  setup :verify_on_exit!

  def do_setup(%{fake_slack: true}) do
    Test.SlackServer.start(testpid: self())

    on_exit fn ->
      Test.SlackServer.stop()
    end
  end

  def do_setup(_) do
  end

  # test "connect/disconnect" do
  #   {:ok, _} = SlackAPI.RTM.start({SlackAPI.RTM.ExampleHandler, [token: "token", url: "http://localhost:51345"]})
  # end

  describe "init" do
    @tag fake_slack: true
    test "with ok" do
      opts = [token: "token", url: "http://localhost:51345"]
      state = Enum.into(opts, %{})

      expect(MockHandler, :init, fn %{self: %{name: "walle"}}, ^opts -> {:ok, state} end)

      assert RTM.init(MockHandler, opts) == {:ok, "ws://localhost:51345/ws", state}
    end

    @tag fake_slack: true
    test "without token" do
      opts = [url: "http://localhost:51345"]
      assert RTM.init(MockHandler, opts) == {:error, :token_not_found}
    end

    @tag fake_slack: true
    test "with web api error" do
      opts = [token: "token", url: "http://localhost:51345/error"]
      assert RTM.init(MockHandler, opts) == {:error, {:web_api, "missing_scope"}}
    end

    @tag fake_slack: true
    test "with handler error" do
      opts = [token: "token", url: "http://localhost:51345"]

      expect(MockHandler, :init, fn %{self: %{name: "walle"}}, ^opts -> {:error, {:handler, "error"}} end)

      assert RTM.init(MockHandler, opts) == {:error, {:handler, "error"}}
    end

    @tag fake_slack: true
    test "with handler exception" do
      opts = [token: "token", url: "http://localhost:51345"]

      expect(MockHandler, :init, fn %{self: %{name: "walle"}}, ^opts -> raise "error" end)

      assert_raise RuntimeError, "error", fn() -> RTM.init(MockHandler, opts) end
    end
  end

  describe "handle_frame" do
    test "with ok" do
      inner_state = %{k: "old"}
      new_inner_state = %{k: "new"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}
      message = ~s({"type":"hello"})

      expect(MockHandler, :handle_message, fn %{type: "hello"}, ^inner_state -> {:ok, new_inner_state} end)

      assert RTM.handle_frame({:text, message}, state) == {:ok, new_state}
    end

    test "with no json message" do
      state = %{handler: MockHandler, state: %{}}

      assert RTM.handle_frame({:text, "message"}, state) == {:ok, state}
    end

    test "without message type" do
      state = %{handler: MockHandler, state: %{}}

      assert RTM.handle_frame({:text, ~s({"ok":true})}, state) == {:ok, state}
    end

    test "with handler error" do
      state = %{handler: TestHandlerWithError, state: %{}}
      message = ~s({"type":"hello"})

      expect(MockErrorHandler, :handle, fn "error" -> :ok end)

      assert RTM.handle_frame({:text, message}, state) == {:ok, state}
    end

    test "with handler exception" do
      state = %{handler: TestHandlerWithException, state: %{}}
      message = ~s({"type":"hello"})

      expect(MockErrorHandler, :handle, fn %RuntimeError{}, _ -> :ok end)

      assert_raise RuntimeError, "error", fn() -> RTM.handle_frame({:text, message}, state) end
    end
  end

  describe "handle_connect" do
    test "with ok" do
      conn = :conn
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_connect, fn ^conn, ^inner_state -> {:ok, new_inner_state} end)

      assert RTM.handle_connect(conn, state) == {:ok, new_state}
    end

    test "with error" do
      state = %{handler: TestHandlerWithError, state: %{inner: "state"}}

      expect(MockErrorHandler, :handle, fn "error" -> :ok end)

      assert RTM.handle_connect(:conn, state) == {:ok, state}
    end

    test "with exception" do
      state = %{handler: TestHandlerWithException, state: %{inner: "state"}}

      expect(MockErrorHandler, :handle, fn %RuntimeError{}, _ -> :ok end)

      assert_raise RuntimeError, "error", fn() -> RTM.handle_connect(:conn, state) end
    end
  end

  describe "handle_disconnect" do
    test "with ok" do
      conn = :conn
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_disconnect, fn ^conn, ^inner_state -> {:ok, new_inner_state} end)

      assert RTM.handle_disconnect(conn, state) == {:ok, new_state}
    end

    test "with reconnect" do
      conn = :conn
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_disconnect, fn ^conn, ^inner_state -> {:reconnect, new_inner_state} end)

      assert RTM.handle_disconnect(conn, state) == {:reconnect, new_state}
    end

    test "with reconnect and connection" do
      conn = :conn
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_disconnect, fn ^conn, ^inner_state -> {:reconnect, :new_conn, new_inner_state} end)

      assert RTM.handle_disconnect(conn, state) == {:reconnect, :new_conn, new_state}
    end

    test "with error" do
      state = %{handler: TestHandlerWithError, state: %{inner: "state"}}

      expect(MockErrorHandler, :handle, fn "error" -> :ok end)

      assert RTM.handle_disconnect(:conn, state) == {:ok, state}
    end

    test "with exception" do
      state = %{handler: TestHandlerWithException, state: %{inner: "state"}}

      expect(MockErrorHandler, :handle, fn %RuntimeError{}, _ -> :ok end)

      assert_raise RuntimeError, "error", fn() -> RTM.handle_disconnect(:conn, state) end
    end
  end

  describe "handle_cast" do
    test "with ok" do
      message = :message
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_cast, fn ^message, ^inner_state -> {:ok, new_inner_state} end)

      assert RTM.handle_cast(message, state) == {:ok, new_state}
    end

    test "with reply" do
      message = :message
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_cast, fn ^message, ^inner_state -> {:reply, :reply_message, new_inner_state} end)

      assert RTM.handle_cast(message, state) == {:reply, :reply_message, new_state}
    end

    test "with close" do
      message = :message
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_cast, fn ^message, ^inner_state -> {:close, new_inner_state} end)

      assert RTM.handle_cast(message, state) == {:close, new_state}
    end

    test "with close and frame" do
      message = :message
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_cast, fn ^message, ^inner_state -> {:close, {1000, "error"}, new_inner_state} end)

      assert RTM.handle_cast(message, state) == {:close, {1000, "error"}, new_state}
    end

    test "with error" do
      state = %{handler: TestHandlerWithError, state: %{inner: "state"}}

      expect(MockErrorHandler, :handle, fn "error" -> :ok end)

      assert RTM.handle_cast(:message, state) == {:ok, state}
    end

    test "with exception" do
      state = %{handler: TestHandlerWithException, state: %{inner: "state"}}

      expect(MockErrorHandler, :handle, fn %RuntimeError{}, _ -> :ok end)

      assert_raise RuntimeError, "error", fn() -> RTM.handle_cast(:message, state) end
    end
  end

  describe "handle_info" do
    test "with ok" do
      message = :message
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_info, fn ^message, ^inner_state -> {:ok, new_inner_state} end)

      assert RTM.handle_info(message, state) == {:ok, new_state}
    end

    test "with reply" do
      message = :message
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_info, fn ^message, ^inner_state -> {:reply, :reply_message, new_inner_state} end)

      assert RTM.handle_info(message, state) == {:reply, :reply_message, new_state}
    end

    test "with close" do
      message = :message
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_info, fn ^message, ^inner_state -> {:close, new_inner_state} end)

      assert RTM.handle_info(message, state) == {:close, new_state}
    end

    test "with close and frame" do
      message = :message
      inner_state = %{inner: "state"}
      new_inner_state = %{inner: "new_state"}
      state = %{handler: MockHandler, state: inner_state}
      new_state = %{handler: MockHandler, state: new_inner_state}

      expect(MockHandler, :handle_info, fn ^message, ^inner_state -> {:close, {1000, "error"}, new_inner_state} end)

      assert RTM.handle_info(message, state) == {:close, {1000, "error"}, new_state}
    end

    test "with error" do
      state = %{handler: TestHandlerWithError, state: %{inner: "state"}}

      expect(MockErrorHandler, :handle, fn "error" -> :ok end)

      assert RTM.handle_info(:message, state) == {:ok, state}
    end

    test "with exception" do
      state = %{handler: TestHandlerWithException, state: %{inner: "state"}}

      expect(MockErrorHandler, :handle, fn %RuntimeError{}, _ -> :ok end)

      assert_raise RuntimeError, "error", fn() -> RTM.handle_info(:message, state) end
    end
  end
end
