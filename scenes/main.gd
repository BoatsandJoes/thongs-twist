extends Node2D
class_name Main

var GameManager = preload("res://scenes/GameManager.tscn")
var game: GameManager

func _ready() -> void:
	go_to_game()

func go_to_game():
	game = GameManager.instantiate()
	add_child(game)
