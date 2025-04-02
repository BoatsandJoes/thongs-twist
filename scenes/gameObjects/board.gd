extends Node2D
class_name Board

var Square = preload("res://scenes/gameObjects/Square/Square.tscn")
var board: Array[Square] = []
var height: int = 7
var width: int = 7

func _ready() -> void:
	for i in height:
		for j in width:
			var square = Square.instantiate()
			add_child(square)
			board.append(square)
	construct_board_visual()

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
