defmodule SlackAPI.Web.DialogTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Dialog

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "open", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "POST", "/api/dialog.open", fn conn ->
      {:ok, request_body, _} = Plug.Conn.read_body(conn)

      assert request_body == ~s<{"trigger_id":"trigger_id","dialog":"dialog"}>
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
      assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Dialog.open(client, "dialog", "trigger_id") == %{ok: true}
  end
end
