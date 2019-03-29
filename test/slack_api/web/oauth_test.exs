defmodule SlackAPI.Web.OauthTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Oauth

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "access" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/oauth.access", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"code":"code","client_secret":"client_secret","client_id":"client_id"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Oauth.access(client, "client_id", "client_secret", "code") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/oauth.access", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)
        test_body = ~s<{"redirect_uri":"/bar","code":"code","client_secret":"client_secret","client_id":"client_id"}>

        assert request_body == test_body
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Oauth.access(client, "client_id", "client_secret", "code", redirect_uri: "/bar") == %{ok: true}
    end
  end

  describe "token" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/oauth.token", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"code":"code","client_secret":"client_secret","client_id":"client_id"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Oauth.token(client, "client_id", "client_secret", "code") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/oauth.token", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)
        test_body = ~s<{"redirect_uri":"/bar","code":"code","client_secret":"client_secret","client_id":"client_id"}>

        assert request_body == test_body
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Oauth.token(client, "client_id", "client_secret", "code", redirect_uri: "/bar") == %{ok: true}
    end
  end
end
