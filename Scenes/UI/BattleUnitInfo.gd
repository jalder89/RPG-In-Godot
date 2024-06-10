extends Control


@onready var health_bar = $HealthBar

var stats : ClassStats:
	set(value):
		stats = value
		connect_stats()

func connect_stats() -> void:
	if not stats is ClassStats: return
	stats.health_changed.connect(_on_stats_health_changed)
	health_bar.set_bar(stats.health, stats.max_health)

func _on_stats_health_changed() -> void:
	health_bar.animate_bar(stats.health, stats.max_health, 2.0)
