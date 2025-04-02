extends Node2D
class_name GameManager

var Board = preload("res://scenes/gameObjects/Board.tscn")
var board: Board
var Cursor = preload("res://scenes/gameObjects/Cursor.tscn")
var cursor: Cursor
var row: int
var col: int
var offset: int

func _ready() -> void:
	board = Board.instantiate()
	offset = board.get_square_size() / 2
	offset = offset + (get_viewport().get_visible_rect().size.y - board.get_square_size() * board.height) / 2
	board.position = board.position + Vector2(offset, offset)
	add_child(board)
	cursor = Cursor.instantiate()
	add_child(cursor)
	row = board.width / 2
	col = board.height / 2
	place_cursor()

func place_cursor():
	cursor.position = Vector2i(offset + (col + 0.5) * board.get_square_size(),
	offset + (row + 0.5) * board.get_square_size())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		if col > 0:
			col = col - 1
			place_cursor()
	elif event.is_action_pressed("right"):
		if col < board.width - 2:
			col = col + 1
			place_cursor()
	elif event.is_action_pressed("up"):
		if row > 0:
			row = row - 1
			place_cursor()
	elif event.is_action_pressed("down"):
		if row < board.height - 2:
			row = row + 1
			place_cursor()
	elif event.is_action_pressed("cw"):
		board.twist(row, col, true)
	elif event.is_action_pressed("ccw"):
		board.twist(row, col, false)
