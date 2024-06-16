extends TextureRect


const CHARACTER_DISPLAY_DURATION = 0.04

var typer : Tween
var is_typing : bool = false

@onready var text_box = %TextBox
@onready var portrait = %Portrait

signal dialog_finished

func _ready() -> void:
	type_dialog("Hi, here is some test dialog.", Resource.new())

func type_dialog(bbcode : String, character : Resource) -> void:
	is_typing = true
	get_tree().paused = true
	show()
	text_box.text = bbcode
	await get_tree().process_frame # Wait for get_total_character_count to be accurate
	var total_characters : int = text_box.get_total_character_count()
	var duration : float = total_characters * CHARACTER_DISPLAY_DURATION
	typer = create_tween()
	typer.tween_method(set_visible_characters, 0, total_characters, duration)
	await typer.finished
	is_typing = false
	emit_signal("dialog_finished")
	

func set_visible_characters(index : int) -> void:
	var is_new_character : bool = index > text_box.visible_characters
	text_box.visible_characters = index
