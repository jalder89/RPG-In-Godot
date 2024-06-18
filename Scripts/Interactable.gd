extends Node
class_name Interactable

func _run_interaction() -> void:
	pass

func get_indefinite_article(item_name) -> String:
	var first_letter = item_name.substr(0, 1).to_lower()
	if first_letter in ["a", "e", "i", "o", "u"]:
		return "an"
	else:
		return "a"
