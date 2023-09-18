extends Node


@onready var enemy_container: Node2D = $EnemyContainer
@onready var spawn_container: Node2D = $SpawnContainer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var difficulty_timer: Timer = $DifficultyTimer
@onready var enemies_killed_label: Label = $CanvasLayer/VBoxContainer/TopRow/HBoxContainer/EnemiesKilledValue
@onready var difficulty_label: Label = $CanvasLayer/VBoxContainer/BottomRow/HBoxContainer/DifficultyValue
@onready var game_over_screen: PanelContainer = $CanvasLayer/GameOverScreen
@onready var restart_button: Button = $CanvasLayer/GameOverScreen/CenterContainer/VBoxContainer/RestartButton

@export var EnemyScene : PackedScene = preload("res://Enemy.tscn")
@export var max_difficulty : int = 20
@export var min_difficulty : int = 1
@export var difficulty : int = min_difficulty

var active_enemy : Enemy = null
var current_character_index: int = -1
var key_typed : String = ""
var enemies_killed : int = 0


func _ready() -> void:
	randomize()
	reset_game()


func find_new_active_enemy(typed_character: String):
	for enemy in enemy_container.get_children():
		var prompt : String = enemy.get_prompt()
		var next_character = prompt.substr(0, 1)
		if next_character == typed_character:
			active_enemy = enemy
			current_character_index = 1
			active_enemy.set_next_character(current_character_index)
#			print("found new enemy that starts with %s" % key_typed)
			return
#	print("No enemy found that starts with %s" % key_typed)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var typed_event = event as InputEventKey
		if typed_event.is_pressed():
			key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
#			print(key_typed)
			if active_enemy == null:
				find_new_active_enemy(key_typed)
			else:
				var prompt = active_enemy.get_prompt()
				var next_character = prompt.substr(current_character_index, 1)
				if key_typed == next_character:
#					print("successfully typed %s" % key_typed)
					current_character_index += 1
					active_enemy.set_next_character(current_character_index)
					if current_character_index == prompt.length():
						enemies_killed += 1
						enemies_killed_label.text = str(enemies_killed)
						current_character_index = -1
						active_enemy.queue_free()
						active_enemy = null
#						print("done")
				else:
					print("unsuccessfully typed %s" % key_typed)


func _on_spawn_timer_timeout() -> void:
	spawn_enemy()


func spawn_enemy():
	var enemy_instance : Enemy = EnemyScene.instantiate()
	enemy_instance.set_difficulty(difficulty)
	var spawn_point = spawn_container.get_children().pick_random()
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawn_point.global_position
	print(str(spawn_point.global_position))


func _on_game_over():
	spawn_timer.stop()
	difficulty_timer.stop()
	print("Lost")
	game_over_screen.show()


func reset_game():
	game_over_screen.hide()
	difficulty = min_difficulty
	difficulty_label.text = str(difficulty)
	active_enemy = null
	current_character_index = -1
	key_typed = ""
	enemies_killed = 0
	enemies_killed_label.text = str(enemies_killed)
	for enemy in enemy_container.get_children():
		enemy.queue_free()
	spawn_enemy()


func _on_difficulty_timer_timeout() -> void:
	difficulty += 1
	difficulty_label.text = str(difficulty)
	Signals.difficulty_increased.emit(difficulty)
#	print("difficulty increased to " + str(difficulty))
	var new_wait_time = spawn_timer.wait_time - 0.2
	spawn_timer.wait_time = clamp(new_wait_time, 0.5, 5)
#	print("new spawn time is " + str(spawn_timer.wait_time))


func _on_restart_button_pressed() -> void:
	print("resetting...")
	reset_game()


func _on_lose_area_body_entered(body: Node2D) -> void:
	_on_game_over()
