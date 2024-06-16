extends Interactable


var inventory : Inventory = ReferenceStash.inventory

var has_apple := true
@export var item : Resource

func _run_interaction() -> void:
	if item is Item:
		inventory.add_item(item)
		var article = get_indefinite_article(item.name)
		Events.emit_signal("request_show_message", "You found " + article + " " + item.name + ".")
		item = null
	else:
		Events.emit_signal("request_show_message", "It's just a barrel...", load("res://Scenes/Characters/ElizabethCharacter.tres"))
