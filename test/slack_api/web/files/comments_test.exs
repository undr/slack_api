defmodule SlackAPI.Web.Files.CommentsTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Files.Comments

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "delete", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "POST", "/api/files.comments.delete", fn conn ->
      {:ok, request_body, _} = Plug.Conn.read_body(conn)

      assert request_body == ~s<{"id":"id","file":"file"}>
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
      assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Comments.delete(client, "file", "id") == %{ok: true}
  end
end
