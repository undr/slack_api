defmodule SlackAPI.Web.AuthTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Auth

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "revoke" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/auth.revoke", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Auth.revoke(client) == %{ok: true}
    end

    test "for test", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/auth.revoke", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "test" => "1"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Auth.revoke(client, test: true) == %{ok: true}
    end

    test "for real", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/auth.revoke", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "test" => "0"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Auth.revoke(client, test: false) == %{ok: true}
    end
  end

  test "test", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "POST", "/api/auth.test", fn conn ->
      {:ok, request_body, _} = Plug.Conn.read_body(conn)

      assert request_body == "{}"
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
      assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Auth.test(client) == %{ok: true}
  end
end
