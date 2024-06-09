extends Node2D
class_name BattleUnit


@export var battle_animations_scene = PackedScene

@onready var root_position := global_position

const ATTACK_OFFSET = 48
var battle_animations : BattleAnimations

func _ready() -> void:
	if battle_animations_scene is PackedScene:
		battle_animations = battle_animations_scene.instantiate()
		add_child(battle_animations)

func melee_attack(target : Node2D):
	z_index = 10
	
	battle_animations.play("Approach")
	var target_position := target.global_position.move_toward(global_position, ATTACK_OFFSET)
	var animation_duration := battle_animations.get_current_animation_length()
	interpolate_position(global_position, target_position, animation_duration)
	await battle_animations.animation_finished
	
	print("Attack!")
	
	battle_animations.play("Melee")
	await battle_animations.animation_finished
	
	battle_animations.play("Return")
	animation_duration = battle_animations.get_current_animation_length()
	interpolate_position(global_position, root_position, animation_duration)
	
	await battle_animations.animation_finished
	
	battle_animations.play("Idle")
	z_index = 0

func interpolate_position(start : Vector2, end : Vector2, duration : float, transition_type : int = Tween.TRANS_LINEAR, easing_type : int = Tween.EASE_IN_OUT) -> void:
	var tween = create_tween().set_trans(transition_type).set_ease(easing_type)
	tween.tween_property(self, "global_position", end, duration).from(start)
	await tween.finished
