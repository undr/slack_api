defmodule SlackAPI.Web.DefMethods do
  defmacro __using__(_opts \\ []) do
    quote location: :keep do
      import unquote(__MODULE__), only: [defpost: 2, defget: 2, defpost: 3, defget: 3, defpost: 4, defget: 4]

      defp normalize(type, params)
      defp normalize(:get, params),
        do: Enum.into(params, [])
      defp normalize(:post, params),
        do: Enum.into(params, %{})

      defp merge(type, params1, params2, keys \\ [])
      defp merge(:get, params1, params2, keys) do
        Keyword.merge(normalize(:get, params1), normalize(:get, params2))
        |> only(keys)
        |> cast_types([])
      end
      defp merge(:post, params1, params2, keys) do
        Map.merge(normalize(:post, params1), normalize(:post, params2))
        |> only(keys)
        |> cast_types(%{})
      end

      defp only(params, []),
        do: params
      defp only(params, key) when is_atom(key),
        do: only(params, [key])
      defp only(params, keys) when is_map(params),
        do: params |> Map.take(keys)
      defp only(params, keys) when is_list(params),
        do: params |> Enum.uniq() |> Keyword.take(keys)

      defp cast_types(params, object),
        do: Enum.reduce(params, object, fn {key, value}, acc -> put_in(acc, [key], cast(value)) end)

      defp cast(true), do: "1"
      defp cast(false), do: "0"
      defp cast(value), do: value
    end
  end

  @doc """
    It generates API method:

        defpost :create, "channels.create", ~w[channel]a, ~w[validate]a

    Will produce:

      def create(client, channel, params \\ %{}) do
        Web.post(client, "channels.create", merge(:post, params, %{channel: channel}, [:channel, :validate]))
      end
  """
  defmacro defpost(name, endpoint),
    do: define_post(name, endpoint, [], [])
  defmacro defpost(name, endpoint, required, optional \\ []),
    do: define_post(name, endpoint, required, optional)

  defp define_post(name, endpoint, required, optional) do
    {required, optional} = prepare_keys(required, optional)
    arguments = Enum.map(required, &Macro.var(&1, nil))
    arguments_map = {:%{}, [], Enum.map(arguments, fn var = {arg, _, _} -> {arg, var} end)}
    keys = required ++ optional

    quote location: :keep do
      def unquote(name)(%SlackAPI.Web{} = client, unquote_splicing(arguments), params \\ %{}) do
        SlackAPI.Web.post(client, unquote(endpoint), merge(:post, params, unquote(arguments_map), unquote(keys)))
      end
    end
  end

  @doc """
    It generates API method:

      defget :info, "channels.info", ~w[channel]a, ~w[include_locale]a

    Will produce:

      def info(client, channel, params \\ []) do
        Web.get(client, "channels.info", merge(:get, params, [channel: channel], [:channel, :include_locale]))
      end
  """
  defmacro defget(name, endpoint),
    do: define_get(name, endpoint, [], [])
  defmacro defget(name, endpoint, required, optional \\ []),
    do: define_get(name, endpoint, required, optional)

  defp define_get(name, endpoint, required, optional) do
    {required, optional} = prepare_keys(required, optional)
    arguments = Enum.map(required, &Macro.var(&1, nil))
    arguments_list = Enum.map(arguments, fn var = {arg, _, _} -> {arg, var} end)
    keys = required ++ optional

    quote location: :keep do
      def unquote(name)(client, unquote_splicing(arguments), params \\ []) do
        SlackAPI.Web.get(client, unquote(endpoint), merge(:get, params, unquote(arguments_list), unquote(keys)))
      end
    end
  end

  defp prepare_keys(required, optional) do
    {required, _} = Code.eval_quoted(required)
    {optional, _} = Code.eval_quoted(optional)

    {to_atoms(required), to_atoms(optional)}
  end

  defp to_atoms(list) do
    Enum.map(list, fn
      item when is_atom(item) -> item
      item when is_binary(item) -> String.to_atom(item)
    end)
  end
end
