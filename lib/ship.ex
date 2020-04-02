defmodule Battleship.Ship do
  defstruct [:name, :health, :length, sunk?: false]

  def new(:carrier) do
    __struct__(%{name: "Carrier", health: 5, length: 5})
  end

  def hit(%__MODULE__{health: 1} = ship) do
    %{ship | health: ship.health - 1, sunk?: true}
  end

  def hit(ship) do
    %{ship | health: ship.health - 1}
  end
end
