extends Node2D

# Managers
var turnManager : TurnManager = ReferenceStash.turnManager

# References
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var player_battle_unit : BattleUnit = $PlayerPosition/PlayerBattleUnit
@onready var player_battle_info := $BattleUI/PlayerBattleInfo
@onready var enemy_battle_unit : BattleUnit = $EnemyPosition/EnemyBattleUnit
@onready var enemy_battle_info := $BattleUI/EnemyBattleInfo
@onready var startup_battle_unit : BattleUnit
@onready var timer = $Timer

# Variables
var asyncTurnPool : AsyncTurnPool = ReferenceStash.asyncTurnPool

func _ready() -> void:
	player_battle_info.stats = player_battle_unit.stats
	enemy_battle_info.stats = enemy_battle_unit.stats
	await animation_player.animation_finished
	
	# AsyncTurnPool setup
	asyncTurnPool.turn_over.connect(_on_async_turn_pool_turn_over)
	
	# Turn manager setup
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

func battle_won() -> void:
	timer.start(0.5)
	await timer.timeout
	var previous_level := player_battle_unit.stats.level
	player_battle_unit.stats.experience += 105
	if player_battle_unit.stats.level > previous_level:
		print("Level Up!")
	pass

func exit_battle() -> void:
	timer.start(1)
	await timer.timeout
	SceneStack.pop()

func _on_startup_turn_started() -> void:
	# Clears turn pool in case of battle ending mid-turn
	asyncTurnPool.active_nodes.clear()
	asyncTurnPool.add(startup_battle_unit)
	# Battle Startup Tasks Go Here
	print("Startup complete")
	# Signals turn_over, trigger _on_start_turn_ended
	asyncTurnPool.remove(startup_battle_unit)

func _on_startup_turn_ended() -> void:
	turnManager.advance_turn()

func _on_ally_turn_started() -> void:
	if not is_instance_valid(player_battle_unit) or player_battle_unit.is_queued_for_deletion():
		timer.start(1)
		await timer.timeout
		get_tree().quit()
		return
	player_battle_unit.melee_attack(enemy_battle_unit)

func _on_ally_turn_ended() -> void:
	print("Ally turn ended!")

func _on_enemy_turn_started() -> void:
	if not is_instance_valid(enemy_battle_unit) or enemy_battle_unit.is_queued_for_deletion():
		await battle_won()
		exit_battle()
		return
	enemy_battle_unit.melee_attack(player_battle_unit)

func _on_enemy_turn_ended() -> void:
	print("Enemy turn ended!")

func _on_async_turn_pool_turn_over() -> void:
	if turnManager.turn_count == 0:
		_on_startup_turn_ended()
	else:
		turnManager.advance_turn()
