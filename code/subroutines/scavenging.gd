extends Node2D


class_name ScavengingSubroutine


@onready var energy_canister : PackedScene = preload("res://data/items/energy_canister.tscn")
@onready var marrow_bottle : PackedScene = preload("res://data/items/marrow_bottle.tscn")
@onready var food_can : PackedScene = preload("res://data/items/food_can.tscn")


var spawn_timer : Timer = Timer.new()

var scavenging_assessment : Dictionary = {
	Constants.RATIONS : 0,
	Constants.ENERGY : 0,
	Constants.OXEN : 0,
}


func _ready() -> void:
	# Connect the signal to the function
	spawn_timer.wait_time = 3
	spawn_timer.one_shot = true
	get_tree().current_scene.add_child.call_deferred(spawn_timer)



func _physics_process(delta: float) -> void:
	if spawn_timer.is_stopped():
		spawn_timer.start()
		print(spawn_timer.is_stopped())
		var random_point = Vector2(randf_range(0, 1400), randf_range(0, 950))
		var random_item = randi() % 3
		var item : Node2D
		if random_item == 0:
			item = energy_canister.instantiate()
		elif random_item == 1:
			item = marrow_bottle.instantiate()
		else:
			item = food_can.instantiate()

		item.position = random_point
		add_child(item)



func _exit_tree() -> void:
	get_tree().current_scene.remove_child(spawn_timer)
	spawn_timer.queue_free()
	
	ResourceManager.modify_resource("rations", scavenging_assessment[Constants.RATIONS])
	ResourceManager.modify_resource("energy", scavenging_assessment[Constants.ENERGY])
	queue_free()
