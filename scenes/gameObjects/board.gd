extends Node2D
class_name Board

var Square = preload("res://scenes/gameObjects/Square/Square.tscn")
var board: Array[Square] = []
var height: int = 7
var width: int = 7
var clearCells: Dictionary[int, Array] = {}
var clearing: bool = false

func _ready() -> void:
	for i in height:
		for j in width:
			var square = Square.instantiate()
			add_child(square)
			board.append(square)
			square.cleared.connect(_on_square_cleared)
	construct_board_visual()

func _on_square_cleared():
	clearing = false

func construct_board_visual():
	for i in height:
		for j in width:
			board[j + i * width].position = Vector2i(j*board[j + i * width].size, i*board[j + i * width].size)

func get_square_size() -> int:
	return board[0].size

func twist(row: int, col: int, clockwise: bool):
	var temp = board[col + row * width]
	if clockwise:
		board[col + row * width] = board[col + (row + 1) * width]
		board[col + (row + 1) * width] = board[col + 1 + (row + 1) * width]
		board[col + 1 + (row + 1) * width] = board[col + 1 + row * width]
		board[col + 1 + row * width] = temp
	else:
		board[col + row * width] = board[col + 1 + row * width]
		board[col + 1 + row * width] = board[col + 1 + (row + 1) * width]
		board[col + 1 + (row + 1) * width] = board[col + (row + 1) * width]
		board[col + (row + 1) * width] = temp
	board[col + row * width].twist(clockwise)
	board[col + (row + 1) * width].twist(clockwise)
	board[col + 1 + (row + 1) * width].twist(clockwise)
	board[col + 1 + row * width].twist(clockwise)
	construct_board_visual()
	check_clears(row, col)

func check_clears(row: int, col: int):
	#each element is one enclosed group. Keys = square indexes
	# and values = Array of Vector2i sides involved in clear.
	var clears: Array[Dictionary] = []
	var cellsToCheck: Dictionary[int,Dictionary] = {
		col + row * width: {Vector2i(-1,0): true, Vector2i(0,-1): true},
		col + 1 + row * width: {Vector2i(1,0): true, Vector2i(0,-1): true},
		col + (row + 1) * width: {Vector2i(-1,0): true, Vector2i(0,1): true},
		col + 1 + (row + 1) * width: {Vector2i(1,0): true, Vector2i(0,1): true}
	}
	while !cellsToCheck.is_empty():
		clearCells = {}
		var cell = cellsToCheck.keys()[0]
		var dir = cellsToCheck[cell].keys()[0]
		cellsToCheck[cell].erase(dir)
		if cellsToCheck[cell].is_empty():
			cellsToCheck.erase(cell)
		if check_square_beginning_from_this_side(cell, dir):
			clears.append(clearCells)
			#Don't check any cell that happens to also be a part of the clear that we just cleared
			for clearedCell in clearCells.keys():
				for clearedDir in clearCells[clearedCell]:
					if cellsToCheck.has(clearedCell):
						if cellsToCheck[clearedCell].has(clearedDir):
							cellsToCheck[clearedCell].erase(clearedDir)
							if cellsToCheck[clearedCell].is_empty():
								cellsToCheck.erase(clearedCell)
	if !clears.is_empty():
		#clear
		clearing = true
		for clear in clears:
			for cell in clear.keys():
				for dir in clear[cell]:
					board[cell].mark(dir)

func check_square_beginning_from_this_side(cell: int, dir: Vector2i) -> bool:
	var square = board[cell]
	var result: bool = true #default value
	if clearCells.has(cell) && clearCells[cell].has(dir):
		return true #already part of this clear
	# add cell/dir to checked cells
	if !clearCells.has(cell):
		clearCells[cell] = []
	clearCells[cell].append(dir)
	var color = board[cell].colors[dir]
	if ((cell % width == 0 && dir.x == -1) || (cell % width == width - 1 && dir.x == 1)
			|| (cell / width == 0 && dir.y == -1) || (cell / width == height - 1 && dir.y == 1)
			|| board[cell % width + dir.x + (cell / width + dir.y) * width].colors[dir * -1] != color):
		result = false
	else:
		#compile directions that match color in this square, and check their neighbors
		var dirsToCheck = [dir]
		if dir.x != null:
			if board[cell].colors[Vector2i(0,1)] == color:
				dirsToCheck.append(Vector2i(0,1))
			if board[cell].colors[Vector2i(0,-1)] == color:
				dirsToCheck.append(Vector2i(0,-1))
		elif dir.y != null:
			if board[cell].colors[Vector2i(1,0)] == color:
				dirsToCheck.append(Vector2i(1,0))
			if board[cell].colors[Vector2i(-1,0)] == color:
				dirsToCheck.append(Vector2i(-1,0))
		if board[cell].colors.has(Vector2i(0,0)) && board[cell].colors[Vector2i(0,0)] == color:
				dirsToCheck.append(dir * -1)
		for checkDir in dirsToCheck:
			#check neighbors on this border
			if !check_square_beginning_from_this_side(cell + checkDir.x + checkDir.y * width, checkDir * -1):
				result = false
				break
	return result
