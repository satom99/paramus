defmodule Paramus do
  defmacro __using__(_options) do
    quote do
      import Ecto.Changeset

      @on_definition {Paramus, :definition}
      @before_compile {Paramus, :compilation}

      Module.register_attribute(__MODULE__, :paramus, accumulate: true)
      @required []
      @optional []

      plug :paramus
    end
  end

  def definition(%{module: module}, _kind, name, _args, _guards, _body) do
    required = module
    |> Module.get_attribute(:required)
    |> Keyword.new

    optional = module
    |> Module.get_attribute(:optional)
    |> Keyword.new

    merged = required ++ optional

    base = Map.new(merged, fn
      {key, {_type, default}} ->
        {key, default}
      {key, _type} ->
        {key, nil}
    end)
    types = Map.new(merged, fn
      {key, {type, _default}} ->
        {key, type}
      other ->
        other
    end)

    validate = Map.keys(types)
    required = Keyword.keys(required)

    final = {base, types, validate, required}

    Module.put_attribute(module, :paramus, {name, final})
    Module.put_attribute(module, :required, [])
    Module.put_attribute(module, :optional, [])
  end

  defmacro compilation(%{module: module}) do
    handlers = module
    |> Module.get_attribute(:paramus)
    |> Enum.reverse
    |> Macro.escape

    errors = module
    |> Module.split
    |> Enum.at(0)
    |> Module.concat(ErrorView)

    quote location: :keep do
      def validate(changeset, _action) do
        changeset
      end

      def paramus(conn, _options) do
        params = conn.params
        action = action_name(conn)
        listed = unquote(handlers)
        {base, types, validate, required} = listed[action]

        {base, types}
        |> cast(params, validate)
        |> validate_required(required)
        |> validate(action)
        |> case do
          %{valid?: true} = changeset ->
            object = changeset
            |> apply_changes
            |> Map.new(fn
              {key, nil} ->
                {key, base[key]}
              other ->
                other
            end)

            params = Map.merge(params, object)
            %{conn | params: params}
          changeset ->
            view = unquote(errors)
            conn
            |> put_status(400)
            |> put_view(view)
            |> render(:"400", changeset: changeset)
            |> halt
        end
      end
    end
  end
end
