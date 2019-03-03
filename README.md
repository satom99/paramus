# Paramus

[![License](https://img.shields.io/github/license/satom99/paramus.svg)](https://github.com/satom99/paramus/blob/master/LICENSE)
[![Hex](http://img.shields.io/hexpm/v/paramus.svg?style=flat)](https://hex.pm/packages/paramus)
[![Donate](https://img.shields.io/badge/donate-PayPal-yellow.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=JKKHNZF6RAKDA&item_name=paramus&currency_code=USD)

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
