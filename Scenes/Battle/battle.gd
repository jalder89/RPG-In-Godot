extends Node2D

# Managers
var turnManager : TurnManager = ReferenceStash.turnManager

# References
@onready var player_battle_unit : BattleUnit = $PlayerPosition/PlayerBattleUnit
@onready var enemy_battle_unit : BattleUnit = $EnemyPosition/EnemyBattleUnit
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var timer = $Timer

# Variables
var startup : bool = true

func _ready() -> void:
	await animation_player.animation_finished
	turnManager.ally_turn_started.connect(_on_ally_turn_started)
	turnManager.ally_turn_ended.connect(_on_ally_turn_ended)
	turnManager.enemy_turn_started.connect(_on_enemy_turn_started)
	turnManager.enemy_turn_ended.connect(_on_enemy_turn_ended)
	turnManager.startup_turn_started.connect(_on_startup_turn_started)
	turnManager.startup_turn_ended.connect(_on_startup_turn_ended)
	turnManager.start()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		SceneStack.pop()

func _on_startup_turn_started() -> void:
	print("Startup started")

func _on_startup_turn_ended() -> void:
	print("Startup ended")
	match randi_range(1, 2):
		1: 
			turnManager.force_ally_turn()
		2:
			turnManager.force_enemy_turn()

func _on_ally_turn_started() -> void:
	print("Ally turn started!")
	await player_battle_unit.melee_attack(enemy_battle_unit)
	turnManager.advance_turn()

func _on_ally_turn_ended() -> void:
	print("Ally turn ended!")

func _on_enemy_turn_started() -> void:
	print("Enemy turn started!")
	await enemy_battle_unit.melee_attack(player_battle_unit)
	turnManager.advance_turn()

func _on_enemy_turn_ended() -> void:
	print("Enemy turn ended!")
