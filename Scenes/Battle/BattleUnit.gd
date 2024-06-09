extends Node2D
class_name BattleUnit


@export var battle_animations_scene = PackedScene

var battle_animations : BattleAnimations

func _ready() -> void:
	if battle_animations_scene is PackedScene:
		battle_animations = battle_animations_scene.instantiate()
		add_child(battle_animations)

func melee_attack():
	battle_animations.play("Approach")
	await battle_animations.animation_finished
	
	print("Attack!")
	
	battle_animations.play("Melee")
	await battle_animations.animation_finished
	
	battle_animations.play("Return")
	await battle_animations.animation_finished
	
	battle_animations.play("Idle")
