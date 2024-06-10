extends Node2D
class_name BattleUnit


@export var stats : ClassStats:
	set(value): 
		stats = value
		if not stats is ClassStats: return
		if battle_animations is BattleAnimations: battle_animations.queue_free()
		battle_animations = stats.battle_animations.instantiate()
		add_child(battle_animations)

@onready var root_position := global_position

const ATTACK_OFFSET = 48
const KNOCKBACK_AMOUNT = 24
var battle_animations : BattleAnimations
var asyncTurnPool : AsyncTurnPool = ReferenceStash.asyncTurnPool

func melee_attack(target : BattleUnit):
	asyncTurnPool.add(self)
	z_index = 10
	
	battle_animations.play("Approach")
	var target_position := target.global_position.move_toward(global_position, ATTACK_OFFSET)
	var animation_duration := battle_animations.get_current_animation_length()
	interpolate_position(global_position, target_position, animation_duration)
	await battle_animations.animation_finished
	
	deal_damage(target)
	target.take_hit(self)
	
	battle_animations.play("Melee")
	await battle_animations.animation_finished
	
	battle_animations.play("Return")
	animation_duration = battle_animations.get_current_animation_length()
	interpolate_position(global_position, root_position, animation_duration)
	
	await battle_animations.animation_finished
	
	battle_animations.play("Idle")
	z_index = 0
	asyncTurnPool.remove(self)

func deal_damage(target : BattleUnit) -> void:
	var damage = snapped(((stats.level * 2 + stats.attack) / 2.0) * (1 - (target.stats.defense / 100.0)), 1)
	print("Target Health: {health}".format({"health": target.stats.health}))
	print("Damage Dealt: {damage}".format({"damage": damage}))
	target.stats.health -= damage
	print("Target Health: {health}".format({"health": target.stats.health}))

func take_hit(attacker : BattleUnit) -> void:
	asyncTurnPool.add(self)
	var knockback_position := global_position.move_toward(attacker.global_position, -KNOCKBACK_AMOUNT)
	interpolate_position(global_position, knockback_position, 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)
	
	if stats.health == 0:
		battle_animations.play("Death")
		await battle_animations.animation_finished
		asyncTurnPool.remove(self)
		queue_free() 
		return
	else:
		battle_animations.play("Hit")
		await battle_animations.animation_finished
		battle_animations.play("Idle")
	
	interpolate_position(global_position, root_position, 0.2, Tween.TRANS_CIRC)
	asyncTurnPool.remove(self)

func interpolate_position(start : Vector2, end : Vector2, duration : float, transition_type : int = Tween.TRANS_LINEAR, easing_type : int = Tween.EASE_IN_OUT) -> void:
	var tween = create_tween().set_trans(transition_type).set_ease(easing_type)
	tween.tween_property(self, "global_position", end, duration).from(start)
	await tween.finished
