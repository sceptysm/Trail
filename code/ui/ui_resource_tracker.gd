extends HBoxContainer

class_name MapResourceTracker

@export var icon : TextureRect
@export var amount : Label


func set_display_amount(new_amount: int) -> void:
	amount.text = str(new_amount)
