defmodule Battleship.Cell do
  defstruct [:coordinate, :ship, state: :empty]
  alias Battleship.Ship

  def new(coordinate), do: __struct__(%{coordinate: coordinate})

  def render(%__MODULE__{ship: %{sunk?: true}} = _cell), do: "X"
  def render(%__MODULE__{state: :empty} = _cell), do: "."
  def render(%__MODULE__{state: :hit} = _cell), do: "H"
  def render(%__MODULE__{state: :miss} = _cell), do: "M"
  def render(%__MODULE__{state: :occupied} = _cell), do: "/"

  def fire_upon(%__MODULE__{state: :occupied} = cell) do
    %{cell | state: :hit}
  end

  def fire_upon(%__MODULE__{state: :empty} = cell) do
    %{cell | state: :miss}
  end

  def place_ship(cell, ship) do
    %{cell | ship: ship, state: :occupied}
  end
end
