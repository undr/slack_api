defmodule SlackAPI.Web.EmojiTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Emoji

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "list", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "GET", "/api/emoji.list", fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert conn.query_params == %{"token" => "token"}
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Emoji.list(client) == %{ok: true}
  end
end
