extends Sprite2D
class_name BattleAnimations


@onready var animation_player : AnimationPlayer = $AnimationPlayer

signal animation_finished

func _ready() -> void:
	animation_player.animation_finished.connect(
		func (_animation):
			animation_finished.emit()
	)

func get_current_animation_length() -> float:
	return animation_player.current_animation_length / animation_player.speed_scale

func play(animation_name : StringName) -> void:
	assert(animation_player.has_animation(animation_name))
	animation_player.play(animation_name)
