defmodule SlackAPI.Web.Files.RemoteTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Files.Remote

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "add" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/files.remote.add", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"title":"title","external_url":"external_url","external_id":"external_id"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.add(client, "external_id", "external_url", "title") == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/files.remote.add", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"title":"title","preview_image":"preview_image","indexable_file_contents":"indexable_file_contents","filetype":"filetype","external_url":"external_url","external_id":"external_id"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.add(
        client,
        "external_id",
        "external_url",
        "title",
        filetype: "filetype",
        indexable_file_contents: "indexable_file_contents",
        preview_image: "preview_image"
      ) == %{ok: true}
    end
  end

  describe "info" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.remote.info", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.info(client) == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.remote.info", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "external_id" => "external_id", "file" => "file"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.info(client, external_id: "external_id", file: "file") == %{ok: true}
    end
  end

  describe "list" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.remote.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.list(client) == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.remote.list", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "channel" => "channel",
          "cursor" => "dXNlcjpVMDYxTkZUVDI=",
          "limit" => "10",
          "ts_from" => "1234567890.123456",
          "ts_to" => "1234567890.123456"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.list(
        client,
        channel: "channel",
        cursor: "dXNlcjpVMDYxTkZUVDI=",
        limit: 10,
        ts_from: "1234567890.123456",
        ts_to: "1234567890.123456"
      ) == %{ok: true}
    end
  end

  describe "remove" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.remote.remove", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.remove(client) == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.remote.remove", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "external_id" => "external_id", "file" => "file"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.remove(client, external_id: "external_id", file: "file") == %{ok: true}
    end
  end

  describe "share" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.remote.share", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "channels" => "channels"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.share(client, "channels") == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.remote.share", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token", "external_id" => "external_id", "file" => "file", "channels" => "channels"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.share(client, "channels", external_id: "external_id", file: "file") == %{ok: true}
    end
  end

  describe "update" do
    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.remote.update", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"token" => "token"}
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.update(client) == %{ok: true}
    end

    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/files.remote.update", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{
          "token" => "token",
          "external_id" => "external_id",
          "external_url" => "external_url",
          "file" => "file",
          "filetype" => "filetype",
          "indexable_file_contents" => "indexable_file_contents",
          "preview_image" => "preview_image",
          "title" => "title"
        }
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Remote.update(
        client,
        external_id: "external_id",
        external_url: "external_url",
        file: "file",
        filetype: "filetype",
        indexable_file_contents: "indexable_file_contents",
        preview_image: "preview_image",
        title: "title"
      ) == %{ok: true}
    end
  end
end
