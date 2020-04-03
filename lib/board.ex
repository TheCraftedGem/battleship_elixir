defmodule Battleship.Board do
  defstruct [:cells]
  alias Battleship.Cell

  def new(:player), do: __struct__(%{cells: generate_cells()})
  def new(:ai), do: __struct__(%{cells: generate_cells()})

  def generate_cells() do
    letters = ?A..?J |> Enum.to_list() |> List.to_string() |> String.codepoints()
    numbers = 1..10 |> Enum.to_list()

    Enum.reduce(letters, %{}, fn letter, acc ->
      Enum.reduce(numbers, acc, fn number, acc ->
        coordinate = letter <> to_string(number)
        Map.merge(acc, %{coordinate => Cell.new(coordinate)})
      end)
    end)
  end

  def place_ship(board, ship, coordinates) do
    cells =
      coordinates
      |> Enum.reduce(board.cells, fn coordinate, acc ->
        cell = board.cells[coordinate]
        %{acc | coordinate => Cell.place_ship(cell, ship)}
      end)

    %{board | cells: cells}
  end

  def valid_placement?(board, ship, coordinates) do
    ship.length == Enum.count(coordinates) &&
      (valid_vertical?(coordinates) || valid_horizontal?(coordinates))
  end

  def valid_horizontal?(coordinates) do
    letters =
      coordinates
      |> Enum.map(fn coordinate -> coordinate |> String.first() end)

    numbers =
      coordinates
      |> Enum.map(fn coordinate -> coordinate |> String.last() end)

    valid_horizontal_letters?(letters) && valid_horizontal_numbers?(numbers)
  end

  def valid_horizontal_numbers?([first_number | _t] = numbers) do
    numbers
    |> Enum.all?(fn letter -> letter == first_number end)
  end

  def valid_horizontal_letters?(letters) do
    input =
      Enum.sort(letters)
      |> List.to_charlist()

    first_number = hd(input)

    valid_numbers = first_number..(first_number + Enum.count(input) - 1) |> Enum.to_list()
    valid_numbers == input
  end

  def valid_vertical?(coordinates) do
    letters =
      coordinates
      |> Enum.map(fn coordinate -> coordinate |> String.first() end)

    numbers =
      coordinates
      |> Enum.map(fn coordinate -> coordinate |> String.last() end)

    valid_vertical_letters?(letters) && valid_vertical_numbers?(numbers)
  end

  def valid_vertical_numbers?(numbers) do
    input =
      Enum.sort(numbers)
      |> List.to_charlist()

    first_number = hd(input)

    valid_numbers = first_number..(first_number + Enum.count(input) - 1) |> Enum.to_list()
    valid_numbers == input
  end

  def valid_vertical_letters?([first_letter | _tail] = letters) do
    letters
    |> Enum.all?(fn letter -> letter == first_letter end)
  end
end
