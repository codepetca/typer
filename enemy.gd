class_name Enemy
extends CharacterBody2D


@onready var prompt : RichTextLabel = $RichTextLabel
@onready var prompt_text #strip_bbcode(prompt.text)

@export var blue : Color = Color.ROYAL_BLUE
@export var green : Color = Color.LAWN_GREEN
@export var gray : Color = Color.GRAY
@export var max_speed : float = 6.0
@export var min_speed : float = 1.0
@export var speed : float = min_speed


func _ready() -> void:
	Signals.difficulty_increased.connect(on_difficulty_increased)
	prompt_text = PromptList.get_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))


func set_difficulty(difficulty: float):
	on_difficulty_increased(difficulty)


func _physics_process(delta: float) -> void:
#	global_position.y += speed
	velocity.y = 100
	move_and_slide()


func get_prompt() -> String:
	return prompt_text


func set_next_character(next_character_index: int):
	var blue_text = get_bbcode_color_tag(blue) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var gray_text = ""
	if next_character_index != prompt_text.length():
		gray_text = get_bbcode_color_tag(gray) + prompt_text.substr(next_character_index + 1, prompt_text.length() - next_character_index) + get_bbcode_end_color_tag()
	prompt.parse_bbcode(set_center_tags(blue_text + green_text + gray_text))


func on_difficulty_increased(new_difficulty: int):
	var new_speed = speed + (0.5 * new_difficulty)
	speed = clamp(new_speed, min_speed, max_speed)


############
#  Helpers
############


func set_center_tags(string_to_center: String):
	return "[center]" + string_to_center + "[/center]"


func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"


func get_bbcode_end_color_tag() -> String:
	return "[/color]"


func strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)
