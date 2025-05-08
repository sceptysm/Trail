extends Node2D

class_name Main

# Retrieve UI elements
@export var overworld_ui : Control
@export var menu_container : PanelContainer
@export var map : Map

@onready var button_container : VBoxContainer = $OverworldUI/MenuContainer/ButtonContainer
@onready var travel_button = $OverworldUI/MenuContainer/ButtonContainer/TravelButton
@onready var scavenge_button = $OverworldUI/MenuContainer/ButtonContainer/ScavengeButton
@onready var status_button = $OverworldUI/MenuContainer/ButtonContainer/StatusButton

@onready var ration_tracker : MapResourceTracker = $OverworldUI/FareResourceContainer/ResourceDisplayBox/RationTracker
@onready var energy_tracker : MapResourceTracker = $OverworldUI/FareResourceContainer/ResourceDisplayBox/EnergyTracker

@onready var scavenging_scene : PackedScene = preload(Constants.SCAVENGING_SCN_PTH)
@onready var popup_scene : PackedScene = preload(Constants.POPUP_SCN_PTH)

var current_screen : Node2D
var current_popup : PanelContainer


####  Setup 
func _ready() -> void:

	# Connect singals to buttons
	print("Connecting signals to buttons...")

	scavenge_button.connect("pressed", func(): on_scavenge_button_pressed())
	status_button.connect("pressed", func(): on_status_button_pressed())	

	ration_tracker.set_display_amount(ResourceManager.get_resources()[Constants.RATIONS])
	energy_tracker.set_display_amount(ResourceManager.get_resources()[Constants.ENERGY])

	SignalBus.resource_changed.connect(on_resource_changed)
	# Connect map signals
	#connect(mouse_clicked.get_name(), func(): on_map_clicked())



###   Input Handling

func _input(event: InputEvent) -> void:
	# Check if the event is a mouse button event
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and map.visible == true:
			pass			


	if event.is_action_pressed("escape"):
		if current_screen == null:
			return

		if current_screen is ScavengingSubroutine:
			map.set_physics_process(true)
			map.show()
			overworld_ui.show()		
			remove_child(current_screen)
			current_screen = null

			

func on_resource_changed(resource_name: String, amount: int) -> void:
	# Update the UI elements based on the resource change
	print("Resource changed: ", resource_name, " Amount: ", amount)
	
	if resource_name == Constants.RATIONS:
		ration_tracker.set_display_amount(amount)

	elif resource_name == Constants.ENERGY:
		energy_tracker.set_display_amount(amount)
	elif resource_name == Constants.OXEN:
		pass


func on_status_button_pressed() -> void:
	# send a popup to the player
	print("Status button pressed")
	
	# show popup at right side of the screen
	var status_popup = popup_scene.instantiate()

	status_popup.position = Vector2(650, 150)
	current_popup = status_popup
	
	overworld_ui.add_child(status_popup)
	overworld_ui.move_to_front()


func on_scavenge_button_pressed() -> void:
	# open the scavenge mini-game
	print("Scavenge button pressed")
	
	# Hide the menu
	overworld_ui.hide()
	
	# pause the map menu and hide it
	map.hide()
	map.set_physics_process(false)

	# Load the scavenging scene
	var scavenging_scene_instance : = scavenging_scene.instantiate()
	current_screen = scavenging_scene_instance
	get_tree().current_scene.add_child(scavenging_scene_instance)
	
