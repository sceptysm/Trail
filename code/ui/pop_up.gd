extends PanelContainer

class_name PopUp


func _ready() -> void:
	# Connect signals to buttons
	connect("gui_input", (func(_event: InputEvent) -> void:
		print("Popup GUI input event: ", _event)

		if _event is InputEventMouseButton and _event.is_pressed():
			queue_free()	
	))

		# popup.connect("gui_input", (func(_event: InputEvent) -> void:
		# 	print("Popup GUI input event: ", _event)
		# 	if current_popup == null:
		# 		return


		# 	if _event is InputEventMouseButton and _event.is_pressed():
		# 		# Hide the popup
		# 		overworld_ui.remove_child(popup)
		# 		current_popup = null
		# 		popup.queue_free()	
		# ))
