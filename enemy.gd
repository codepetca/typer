class_name Enemy
extends Sprite2D


@onready var prompt : RichTextLabel = $RichTextLabel
@onready var prompt_text #strip_bbcode(prompt.text)

@export var blue : Color = Color.ROYAL_BLUE
@export var green : Color = Color.LAWN_GREEN
@export var gray : Color = Color.GRAY
@export var speed : float = 1.0


func _ready() -> void:
	prompt_text = PromptList.get_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))


func _physics_process(delta: float) -> void:
	global_position.y += speed


func get_prompt() -> String:
	return prompt_text


func set_next_character(next_character_index: int):
	var blue_text = get_bbcode_color_tag(blue) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var gray_text = ""
	if next_character_index != prompt_text.length():
		gray_text = get_bbcode_color_tag(gray) + prompt_text.substr(next_character_index + 1, prompt_text.length() - next_character_index) + get_bbcode_end_color_tag()
	prompt.parse_bbcode(set_center_tags(blue_text + green_text + gray_text))


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
