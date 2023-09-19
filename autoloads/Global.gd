extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SilentWolf.configure({
	"api_key": "JEFlUqfiin463jOFpi98b7ujddKqt7os9nFwaCvz",
	"game_id": "Typer",
	"log_level": 1
	})

	SilentWolf.configure_scores({
	"open_scene_on_close": "res://scenes/MainPage.tscn"
	})


