defmodule SlackAPI.WebTest do
  use ExUnit.Case

  alias SlackAPI.Web

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  test "get_token", %{client: client} do
    assert Web.get_token(client) == "token"
  end

  test "get_url", %{client: client} do
    assert Web.get_url(client, "api.test") == "http://localhost:51346/api/api.test"
  end

  describe "post" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/endpoint", fn conn ->
        {:ok, "", _} = Plug.Conn.read_body(conn)
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Web.post(client, "endpoint") == %{ok: true}
    end

    test "json keyword params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/endpoint", fn conn ->
        {:ok, ~s<{"param2":"val2","param1":"val1"}>, _} = Plug.Conn.read_body(conn)
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Web.post(client, "endpoint", [param1: "val1", param2: "val2"]) == %{ok: true}
    end

    test "json map params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/endpoint", fn conn ->
        {:ok, ~s<{"param2":"val2","param1":"val1"}>, _} = Plug.Conn.read_body(conn)
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Web.post(client, "endpoint", %{param1: "val1", param2: "val2"}) == %{ok: true}
    end
  end

  describe "get" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/endpoint", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Web.get(client, "endpoint") == %{ok: true}
    end

    test "keyword params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/endpoint", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"param1" => "val1", "param2" => "val2", "token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Web.get(client, "endpoint", [param1: "val1", param2: "val2"]) == %{ok: true}
    end

    test "map params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/endpoint", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"param1" => "val1", "param2" => "val2", "token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Web.get(client, "endpoint", %{param1: "val1", param2: "val2"}) == %{ok: true}
    end
  end
end
