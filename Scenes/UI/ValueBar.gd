extends TextureRect


@onready var decrease := $Decrease
@onready var increase := $Increase
@onready var actual := $Actual
@onready var timer = $Timer

signal animation_finish
var bar_value : float = 0.0

func _ready() -> void:
	set_bar(100, 100)

# Animation Tests
#func _process(delta):
	#if Input.is_action_just_pressed("ui_accept"):
		#print("Oof, you lost half your health!")
		#animate_bar(50, 100, 2)
		#timer.start(2)
		#await timer.timeout
		#print("Yay! You've healed 25% of your health!")
		#animate_bar(75, 100, 2)

func set_bar_value(value : float, max_value : float) -> void:
	bar_value = (value / max_value) * 100
	
func set_bar(value : float, max_value : float) -> void:
	set_bar_value(value, max_value)
	decrease.value = bar_value
	increase.value = bar_value
	actual.value = bar_value

func animate_bar(value : float, max_value : float, duration : float = 2.0) -> void:
	var previous_bar_value = bar_value
	set_bar_value(value, max_value)
	var tween := create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	if bar_value > previous_bar_value:
		decrease.value = bar_value
		increase.value = bar_value
		tween.tween_property(actual, "value", bar_value, duration).from_current()
		await tween.finished
	elif bar_value < previous_bar_value:
		actual.value = bar_value
		increase.value = bar_value
		tween.tween_property(decrease, "value", bar_value, duration).from_current()
	else:
		tween.kill()
	emit_signal("animation_finish")
