extends TextureRect


const CHARACTER_DISPLAY_DURATION = 0.04

var typer : Tween
var is_typing : bool = false

@onready var text_box = %TextBox
@onready var portrait = %Portrait
@onready var name_box = %NameBox

func _ready() -> void:
	Events.request_show_dialog.connect(type_dialog)

func _unhandled_input(event : InputEvent) -> void:
	if not visible: return
	if not event.is_action_pressed("ui_accept"): return
	if is_typing:
		is_typing = false
		if typer is Tween: typer.kill()
		text_box.visible_ratio = 1.0
	else:
		hide()
		get_tree().root.set_input_as_handled()
		get_tree().paused = false
		Events.emit_signal("dialog_finished")

func type_dialog(bbcode : String, character : Character) -> void:
	is_typing = true
	portrait.texture = character.portrait
	name_box.text = character.name
	get_tree().paused = true
	show()
	text_box.text = bbcode
	var total_characters : int = text_box.text.length()
	var duration : float = total_characters * CHARACTER_DISPLAY_DURATION
	typer = create_tween()
	typer.tween_method(set_visible_characters, 0, total_characters, duration)
	await typer.finished
	is_typing = false
	

func set_visible_characters(index : int) -> void:
	var is_new_character : bool = index > text_box.visible_characters
	text_box.visible_characters = index
	if is_new_character and index < text_box.text.length():
		pass
