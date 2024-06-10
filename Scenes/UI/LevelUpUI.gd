extends TextureRect


@onready var experience_bar = %ExperienceBar

func level_up() -> void:
	show()
	experience_bar.set_bar(25, 100)
	await experience_bar.animate_bar(100, 100, 2.0)
