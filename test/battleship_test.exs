defmodule BattleshipTest do
  use ExUnit.Case
  doctest Battleship

  alias Battleship.{Ship, Cell, Board}

  test "create ship with attributes" do
    carrier = Ship.new(:carrier)

    assert carrier.name == "Carrier"
    assert carrier.health == 5
    assert carrier.length == 5
    assert carrier.sunk? == false
  end

  test "ship can take hits and be sunk" do
    carrier = Ship.new(:carrier)

    carrier =
      carrier
      |> Ship.hit()

    assert carrier.health == 4

    carrier =
      carrier
      |> Ship.hit()
      |> Ship.hit()
      |> Ship.hit()
      |> Ship.hit()

    assert carrier.health == 0
    assert carrier.sunk? == true
  end

  test "cell can be created" do
    cell = Cell.new("A1")

    assert cell.coordinate == "A1"
    assert cell.state == :empty
    assert cell.ship == nil
  end

  test "can place ship in cell" do
    cell = Cell.new("A1")
    carrier = Ship.new(:carrier)

    cell =
      cell
      |> Cell.place_ship(carrier)

    assert cell.ship == carrier
    assert cell.state == :occupied
    assert cell.coordinate == "A1"
  end

  test "cell renders output based on state" do
    cell = Cell.new("A1")

    render =
      cell
      |> Cell.render()

    assert render == "."

    carrier = Ship.new(:carrier)

    render =
      cell
      |> Cell.place_ship(carrier)
      |> Cell.render()

    assert render == "/"
  end

  # test "can fire upon cell and damage ship and renders accordingly" do
  #   carrier = Ship.new(:carrier)

  #   cell = Cell.new("A1")
  #   |> Cell.place_ship(carrier)

  #   render = cell
  #   |> Cell.render()
  #   assert render == "H"
  # end

  test "cell renders X for sunk ship" do
    carrier =
      Ship.new(:carrier)
      |> Ship.hit()
      |> Ship.hit()
      |> Ship.hit()
      |> Ship.hit()
      |> Ship.hit()

    render =
      Cell.new("A1")
      |> Cell.place_ship(carrier)
      |> Cell.render()

    assert render == "X"
  end

  test "create board with cells" do
    board = Board.new(:player)

    expected = Enum.count(board.cells)
    assert expected == 100
  end

  test "can place valid ship on board" do
    board = Board.new(:player)
    carrier = Ship.new(:carrier)

    coordinates = ["A1", "A2", "A3", "A4", "A5"]

    board =
      board
      |> Board.place_ship(carrier, coordinates)

    assert board.cells["A1"].state == :occupied
    assert board.cells["A2"].state == :occupied
    assert board.cells["A3"].state == :occupied
    assert board.cells["A4"].state == :occupied
    assert board.cells["A5"].state == :occupied
  end
end
