extends Interactable

@onready var sprite_2d = $Sprite2D

@export var item : Item:
	set(value):
		item = value
		(func ():
			if sprite_2d:
				sprite_2d.texture = item.overworld_sprite
		).call_deferred()

var inventory : Inventory = ReferenceStash.inventory

func _run_interaction() -> void:
	inventory.add_item(item)
	var article = get_indefinite_article(item.name)
	Events.emit_signal("request_show_message", "You've found " + article + " " + item.name + "!\n" + item.description)
	queue_free()

func get_indefinite_article(name) -> String:
	var first_letter = name.substr(0, 1).to_lower()
	if first_letter in ["a", "e", "i", "o", "u"]:
		return "an"
	else:
		return "a"
