defmodule Mark001 do
  def create_board() do
    [
      %{x: 0, y: 0, cell: 'x'},
      %{x: 0, y: 1, cell: 'x'},
      %{x: 0, y: 2, cell: 'x'},
      %{x: 1, y: 0, cell: 'x'},
      %{x: 1, y: 1, cell: 'x'},
      %{x: 1, y: 2, cell: 'x'},
      %{x: 2, y: 0, cell: 'x'},
      %{x: 2, y: 1, cell: 'x'},
      %{x: 2, y: 2, cell: 'x'}
    ]
  end

  def get_cell(board, x, y) do
    Enum.find(board, fn(tuple) -> tuple[:x] == x && tuple[:y] == y end)
  end

  def revive_cell(board, x, y) do
    Enum.map(board, fn(tuple) -> update_cell(tuple, x, y, 'o') end)
  end

  def kill_cell(board, x, y) do
    Enum.map(board, fn(tuple) -> update_cell(tuple, x, y, 'x') end)
  end

  def check_conway_rules(cell) do
    case {cell[:cell], cell[:neighbor]} do
      {'x', 3}            -> update_cell(cell, cell[:x], cell[:y], 'o')
      {'o', n} when n < 2 -> update_cell(cell, cell[:x], cell[:y], 'x')
      {'o', n} when n > 3 -> update_cell(cell, cell[:x], cell[:y], 'x')
      {_,_}               -> cell
    end
  end

  def update_cell(tuple, x, y, new_state) do
    case tuple do
      %{x: ^x, y: ^y, cell: _} -> Map.merge(tuple, %{cell: new_state})
      _                        -> tuple
    end
  end

  def next_generation(board) do
    count_neighbors(board) |>
    Enum.map(fn(cell) -> check_conway_rules(cell) end)
  end

  def count_neighbors(board) do
    Enum.map(board, fn(cell) -> Map.merge(cell, %{neighbor: count(board, cell)}) end)
  end

  def count(board, cell) do
    [
      %{x: cell[:x] - 1, y: cell[:y] - 1},
      %{x: cell[:x] - 1, y: cell[:y]},
      %{x: cell[:x] - 1, y: cell[:y] + 1},
      %{x: cell[:x], y: cell[:y] - 1},
      %{x: cell[:x], y: cell[:y] + 1},
      %{x: cell[:x] + 1, y: cell[:y] - 1},
      %{x: cell[:x] + 1, y: cell[:y]},
      %{x: cell[:x] + 1, y: cell[:y] + 1}
    ] 
    |> Enum.filter(fn(neighbor) -> neighbor[:x] >= 0 || neighbor[:y] >= 0 end) 
    |> Enum.map(fn(neighbor) -> get_cell(board, neighbor[:x], neighbor[:y])[:cell] == 'o' end)
    |> Enum.filter(fn(x) -> x end)
    |> Enum.count()    
  end
end
