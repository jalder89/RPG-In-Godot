extends CharacterBody2D


const WALK_SPEED = 80

@onready var animated_sprite_2d := $AnimatedSprite2D
@onready var interactable_detector := $InteractableDetector

func _ready() -> void:
	interactable_detector.rotation = Vector2.DOWN.angle()

func _physics_process(_delta : float) -> void:
	var input_vector = Input.get_vector("left", "right", "up", "down")
	velocity = input_vector * WALK_SPEED
	move_and_slide()
	
	if is_moving():
		animate_walk()
		interactable_detector.rotation = velocity.angle()
	else:
		animate_idle()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var interactables : Array = interactable_detector.get_overlapping_bodies()
		for interactable in interactables:
			if not interactable is Interactable: continue
			interactable._run_interaction()
			get_tree().root.set_input_as_handled()
	if event.is_action_pressed("battle"):
		SceneStack.push("res://Scenes/Battle/battle.tscn")

func is_moving() -> bool:
	return velocity != Vector2.ZERO

func animate_walk() -> void:
	var angle : float = velocity.angle()
	var angle_in_degrees : float = rad_to_deg(angle)
	var rounded_angle : int = int(snapped(angle_in_degrees, 45))
	match rounded_angle:
		-135, 180, 135: animated_sprite_2d.animation = "WalkLeft"
		0, 45, -45: animated_sprite_2d.animation = "WalkRight"
		-90: animated_sprite_2d.animation = "WalkUp"
		90: animated_sprite_2d.animation = "WalkDown"
		
func animate_idle() -> void:
	match animated_sprite_2d.animation:
		"WalkLeft": animated_sprite_2d.animation = "IdleLeft"
		"WalkRight": animated_sprite_2d.animation = "IdleRight"
		"WalkUp": animated_sprite_2d.animation = "IdleUp"
		"WalkDown": animated_sprite_2d.animation = "IdleDown"
