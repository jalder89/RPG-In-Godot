extends NPC


const ELIZABETH_CHARACTER : Character = preload("res://Scenes/Characters/ElizabethCharacter.tres")
const APPLE_ITEM : Item = preload("res://Scenes/Prefabs/Items/AppleItem.tres")

var has_apple := false
var inventory = ReferenceStash.inventory

func _run_interaction() -> void:
	if not has_apple:
		Events.emit_signal("request_show_dialog", "Aaaaaah! I have a headache...", character)
		await Events.dialog_finished
		Events.emit_signal("request_show_dialog", "Can you find an apple for me?", character)
		await Events.dialog_finished
		var apple = inventory.remove_item(APPLE_ITEM)
		if apple is Item:
			Events.emit_signal("request_show_dialog", "I actually have one right here!", ELIZABETH_CHARACTER)
			await Events.dialog_finished
			has_apple = true
		else:
			Events.emit_signal("request_show_dialog", "I don't have one on me, but I'll look around for you.", ELIZABETH_CHARACTER)
			await Events.dialog_finished
	if has_apple:
		Events.emit_signal("request_show_dialog", "I feel much better now.", character)
		await Events.dialog_finished
		Events.emit_signal("request_show_dialog", "Thank you!", character)
		await Events.dialog_finished
		Events.emit_signal("request_show_dialog", "You're welcome, Stumpy.", ELIZABETH_CHARACTER)
		await Events.dialog_finished
