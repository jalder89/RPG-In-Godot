extends Camera2D
class_name BattleCamera

const PARALLAX_OFFSET = Vector2(0, -30)
const CAMERA_OFFSET = Vector2(0, 10)

func focus_target(target_position : Vector2, target_zoom : Vector2, parallaxBackground : ParallaxBackground, parallaxForeground : ParallaxBackground, duration : float = 0.4) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target_position, duration).from_current()
	tween.parallel().tween_property(self, "zoom", target_zoom, duration).from_current()
	tween.parallel().tween_property(self, "offset", CAMERA_OFFSET, duration).from_current()
	tween.parallel().tween_property(parallaxBackground, "offset", PARALLAX_OFFSET, duration).from_current()
	tween.parallel().tween_property(parallaxForeground, "offset", PARALLAX_OFFSET, duration).from_current()
	await tween.finished

func center_target(target_position : Vector2, target_zoom : Vector2, parallaxBackground : ParallaxBackground, parallaxForeground : ParallaxBackground, duration : float = 0.4) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target_position, duration).from_current()
	tween.parallel().tween_property(self, "zoom", target_zoom, duration).from_current()
	tween.parallel().tween_property(self, "offset", Vector2.ZERO, duration).from_current()
	tween.parallel().tween_property(parallaxBackground, "offset", Vector2.ZERO, duration).from_current()
	tween.parallel().tween_property(parallaxForeground, "offset", Vector2.ZERO, duration).from_current()
	await tween.finished
