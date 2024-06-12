extends Resource
class_name Item

@export var name : String
@export_multiline var description : String
@export var amount : int = 1: set = _set_amount

func _set_amount(value : int) -> void:
	amount = max(0, value)
