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
	Events.emit_signal("request_show_message", "You've found " + article + " " + item.name + "!")
	queue_free()
