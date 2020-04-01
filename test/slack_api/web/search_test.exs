defmodule SlackAPI.Web.SearchTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Search

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "all" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/search.all", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "query" => "query"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Search.all(client, "query") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/search.all", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "query" => "query",
          "count" => "10",
          "highlight" => "1",
          "page" => "1",
          "sort" => "score",
          "sort_dir" => "desc"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Search.all(
        client,
        "query",
        count: 10,
        highlight: true,
        page: 1,
        sort: :score,
        sort_dir: :desc
      ) == %{ok: true}
    end
  end

  describe "files" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/search.files", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "query" => "query"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Search.files(client, "query") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/search.files", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "query" => "query",
          "count" => "10",
          "highlight" => "1",
          "page" => "1",
          "sort" => "score",
          "sort_dir" => "desc"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Search.files(
        client,
        "query",
        count: 10,
        highlight: true,
        page: 1,
        sort: :score,
        sort_dir: :desc
      ) == %{ok: true}
    end
  end

  describe "messages" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/search.messages", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "query" => "query"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Search.messages(client, "query") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/search.messages", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "query" => "query",
          "count" => "10",
          "highlight" => "1",
          "page" => "1",
          "sort" => "score",
          "sort_dir" => "desc"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Search.messages(
        client,
        "query",
        count: 10,
        highlight: true,
        page: 1,
        sort: :score,
        sort_dir: :desc
      ) == %{ok: true}
    end
  end
end
