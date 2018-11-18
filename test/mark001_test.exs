defmodule Mark001Test do
  use ExUnit.Case

  test "#create_board a board of 9 dead cells" do
    board = Mark001.create_board()
    assert Enum.map(board, fn(cell) -> cell[:cell] end) == ['x','x','x','x','x','x','x','x','x']
  end

  test "#get_cell returns a cell" do
    board = Mark001.create_board()
    assert Mark001.get_cell(board, 1, 0) == %{x: 1, y: 0, cell: 'x'}
  end

  test "#revive_cell revice cell at (x,y)" do
    board = Mark001.create_board() |>
    Mark001.revive_cell(1, 0)
    assert Mark001.get_cell(board, 1, 0) == %{x: 1, y: 0, cell: 'o'}
  end

  test "#update_cell with match cell its updated" do
    cell = %{x: 1, y: 0, cell: 'o'}
    assert Mark001.update_cell(cell, 1, 0, 'x') == %{x: 1, y: 0, cell: 'x'}
  end

  test "#update_cell without match cell its not updated" do
    cell = %{x: 1, y: 0, cell: 'o'}
    assert Mark001.update_cell(cell, 1, 1, 'x') == %{x: 1, y: 0, cell: 'o'}
  end

  test "#kill_cell" do
    board = Mark001.create_board() |>
    Mark001.revive_cell(1, 0) |>
    Mark001.kill_cell(1, 0) 
    assert Mark001.get_cell(board, 1, 0) == %{x: 1, y: 0, cell: 'x'}
  end
  
  test "#next_generation any live cell with less than 2 neighbors dies" do
    board = Mark001.create_board() |>
    Mark001.revive_cell(0, 0) |>
    Mark001.next_generation()
    
    assert Mark001.get_cell(board, 0, 0)[:cell] == 'x'
  end

  test "#next_generation any live cell with 2 or 3 neighbors lives" do
    board = Mark001.create_board() |>
    Mark001.revive_cell(0, 0) |>
    Mark001.revive_cell(0, 1) |>
    Mark001.revive_cell(0, 2) |>
    Mark001.next_generation()
    
    assert Mark001.get_cell(board, 0, 1)[:cell] == 'o'
  end

  test "#next_generation any live cell with more than 3 neighbors dies" do
    board = Mark001.create_board() |>
    Mark001.revive_cell(0, 0) |>
    Mark001.revive_cell(0, 1) |>
    Mark001.revive_cell(0, 2) |>
    Mark001.revive_cell(1, 0) |>
    Mark001.revive_cell(1, 1) |>
    Mark001.next_generation()
    
    assert Mark001.get_cell(board, 1, 1)[:cell] == 'x'
  end

  test "#next_generation any dead cell with 3 neighbors comes to live" do
    board = Mark001.create_board() |>
    Mark001.revive_cell(0, 0) |>
    Mark001.revive_cell(1, 0) |>
    Mark001.revive_cell(0, 1) |>
    Mark001.next_generation()
    
    assert Mark001.get_cell(board, 1, 1)[:cell] == 'o'
  end

  test "#count_neighbors" do
    neighbors = Mark001.create_board() |>
    Mark001.revive_cell(0, 0) |>
    Mark001.revive_cell(1, 0) |>
    Mark001.revive_cell(0, 1) |>
    Mark001.count_neighbors

    assert Mark001.get_cell(neighbors, 1, 1)[:neighbor] == 3
  end
end
