defmodule SlackAPI.Web.ChatTest do
  use ExUnit.Case

  alias SlackAPI.Web
  alias SlackAPI.Web.Chat

  setup _ do
    bypass = Bypass.open(port: 51346)
    client = Web.new(token: "token", url: "http://localhost:51346")

    {:ok, bypass: bypass, client: client}
  end

  describe "delete" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.delete", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"ts":"1234567890.123456","channel":"#channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.delete(client, "#channel", "1234567890.123456") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.delete", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"ts":"1234567890.123456","channel":"#channel","as_user":"1"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.delete(client, "#channel", "1234567890.123456", as_user: true) == %{ok: true}
    end
  end

  describe "delete_scheduled_message" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.deleteScheduledMessage", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"scheduled_message_id":"12345","channel":"#channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.delete_scheduled_message(client, "#channel", "12345") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.deleteScheduledMessage", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"scheduled_message_id":"12345","channel":"#channel","as_user":"1"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.delete_scheduled_message(client, "#channel", "12345", as_user: true) == %{ok: true}
    end
  end

  test "get_permalink", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "GET", "/api/chat.getPermalink", fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert conn.query_params == %{"token" => "token", "message_ts" => "1234567890.123456", "channel" => "channel"}
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Chat.get_permalink(client, "channel", "1234567890.123456") == %{ok: true}
  end

  test "me_message", %{client: client, bypass: bypass} do
    Bypass.expect bypass, "POST", "/api/chat.meMessage", fn conn ->
      {:ok, request_body, _} = Plug.Conn.read_body(conn)

      assert request_body == ~s<{"text":"text","channel":"#channel"}>
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
      assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
      assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
      Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
    end

    assert Chat.me_message(client, "#channel", "text") == %{ok: true}
  end

  describe "post_ephemeral" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.postEphemeral", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"user":"user","text":"text","channel":"#channel","attachments":{"text":"text"}}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.post_ephemeral(client, %{"text" => "text"}, "#channel", "text", "user") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.postEphemeral", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"user":"user","thread_ts":"1234567890.123456","text":"text","parse":"full","link_names":"1","channel":"#channel","attachments":{"text":"text"},"as_user":"1"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.post_ephemeral(
        client,
        %{"text" => "text"},
        "#channel",
        "text",
        "user",
        as_user: true,
        link_names: true,
        parse: "full",
        thread_ts: "1234567890.123456"
      ) == %{ok: true}
    end
  end

  describe "post_message" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.postMessage", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"text":"text","channel":"#channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.post_message(client, "#channel", "text") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.postMessage", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"unfurl_media":"1","unfurl_links":"1","thread_ts":"1234567890.123456","text":"text","reply_broadcast":"1","parse":"full","mrkdwn":"1","link_names":"1","channel":"#channel","attachments":{"text":"text"},"as_user":"1"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.post_message(
        client,
        "#channel",
        "text",
        as_user: true,
        attachments: %{"text" => "text"},
        link_names: true,
        mrkdwn: true,
        parse: "full",
        reply_broadcast: true,
        thread_ts: "1234567890.123456",
        unfurl_links: true,
        unfurl_media: true
      ) == %{ok: true}
    end
  end

  describe "schedule_message" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.scheduleMessage", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"text":"text","post_at":"299876400","channel":"#channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.schedule_message(client, "#channel", "299876400", "text") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.scheduleMessage", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"unfurl_media":"1","unfurl_links":"1","thread_ts":"1234567890.123456","text":"text","reply_broadcast":"1","post_at":"299876400","parse":"full","link_names":"1","channel":"#channel","attachments":{"text":"text"},"as_user":"1"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.schedule_message(
        client,
        "#channel",
        "299876400",
        "text",
        as_user: true,
        attachments: %{"text" => "text"},
        link_names: true,
        parse: "full",
        reply_broadcast: true,
        thread_ts: "1234567890.123456",
        unfurl_links: true,
        unfurl_media: true
      ) == %{ok: true}
    end
  end

  describe "unfurl" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.unfurl", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"unfurls":"unfurls","ts":"1234567890.123456","channel":"#channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.unfurl(client, "#channel", "1234567890.123456", "unfurls") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.unfurl", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"user_auth_url":"http://user_auth_url","user_auth_required":"1","user_auth_message":"user_auth_message","unfurls":"unfurls","ts":"1234567890.123456","channel":"#channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.unfurl(
        client,
        "#channel",
        "1234567890.123456",
        "unfurls",
        user_auth_message: "user_auth_message",
        user_auth_required: true,
        user_auth_url: "http://user_auth_url"
      ) == %{ok: true}
    end
  end

  describe "update" do
    test "without params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.update", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"ts":"1234567890.123456","text":"text","channel":"#channel"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.update(client, "#channel", "1234567890.123456", "text") == %{ok: true}
    end

    test "with params", %{client: client, bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/chat.update", fn conn ->
        {:ok, request_body, _} = Plug.Conn.read_body(conn)

        assert request_body == ~s<{"ts":"1234567890.123456","text":"text","parse":"1","link_names":"1","channel":"#channel","attachments":{"text":"text"},"as_user":"1"}>
        assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer token"]
        assert Plug.Conn.get_req_header(conn, "content-type") == ["application/json;charset=utf-8"]
        assert Plug.Conn.get_req_header(conn, "accept") == ["application/json;charset=utf-8"]
        Plug.Conn.resp(conn, 200, ~s<{"ok":true}>)
      end

      assert Chat.update(
        client,
        "#channel",
        "1234567890.123456",
        "text",
        as_user: true,
        attachments: %{text: "text"},
        link_names: true,
        parse: true
      ) == %{ok: true}
    end
  end
end
