defmodule Battleship.Board do
  defstruct [:cells]
  alias Battleship.Cell

  def new(:player), do: __struct__(%{cells: generate_cells()})
  def new(:ai), do: __struct__(%{cells: generate_cells()})

  def generate_cells() do
    letters = ?A..?J |> Enum.to_list() |> List.to_string() |> String.codepoints()
    numbers = 1..10  |> Enum.to_list()

    Enum.reduce(letters, %{}, fn letter, acc ->
      Enum.reduce(numbers, acc, fn number, acc ->
        coordinate = letter <> to_string(number)
        Map.merge(acc, %{coordinate => Cell.new(coordinate)})
      end)
    end)
  end

  def place_ship(board, ship, [coordinate]) do
    cell = board.cells[coordinate]
    cells = %{board.cells | coordinate =>  Cell.place_ship(cell, ship)}
    %{board | cells: cells}
  end
end
