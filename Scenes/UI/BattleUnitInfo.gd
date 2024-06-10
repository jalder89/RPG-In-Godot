extends Control


@onready var health_bar := $HealthBar
@onready var level_label := $LevelLabel

var stats : ClassStats:
	set(value):
		stats = value
		connect_stats()

func update_level() -> void:
	level_label.text = "Level: " + str(stats.level)

func connect_stats() -> void:
	if not stats is ClassStats: return
	stats.health_changed.connect(_on_stats_health_changed)
	stats.level_changed.connect(_on_stats_level_changed)
	health_bar.set_bar(stats.health, stats.max_health)
	update_level()

func _on_stats_health_changed() -> void:
	health_bar.animate_bar(stats.health, stats.max_health, 2.0)

func _on_stats_level_changed() -> void:
	update_level()
