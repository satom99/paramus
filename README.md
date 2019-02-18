# Paramus

Parameter validation for [Phoenix](https://github.com/phoenixframework/phoenix).

### Example

```elixir
defmodule Example.Routes.Fruit do
  use Phoenix.Controller
  use Paramus

  @required [
    name: :string,
    quantity: :integer
  ]
  @optional [
    cut?: {:boolean, false}
  ]
  def consume(conn, %{name: name, quantity: quantity, cut?: cut?}) do
    # ···
  end

  def validate(changeset, :consume) do
    changeset
    |> validate_length(:name, min: 3)
    |> validate_number(:quantity, less_than: 5)
  end
end
```
