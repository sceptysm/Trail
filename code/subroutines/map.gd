extends Node2D

class_name Map

@export var map_viewport : Viewport
@export var map_viewport_container : SubViewportContainer
@export var player_sprite : AnimatedSprite2D
@export var player_marker : MapPlayerMarker
@export var target_marker : PackedScene
@export var message_log : ScrollContainer
@export var message_log_container : VBoxContainer
@export var message_log_theme : Theme

var target_marker_instance : Sprite2D
var tick_timer : Timer = Timer.new()

const NO_TARGET : Vector2 = Vector2(-1, -1)

func _ready() -> void:
	# Connect signals
	SignalBus.map_clicked.connect(on_map_clicked)

	tick_timer.one_shot = true
	tick_timer.wait_time = Constants.TICK_INTERVAL	
	get_tree().current_scene.add_child.call_deferred(tick_timer)
	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and self.visible == true:

			var mouse_position = event.position

			if is_within_viewport(mouse_position):
				SignalBus.map_clicked.emit()


func _physics_process(_delta: float) -> void:
	var target_position : Vector2 = player_marker.target_position

	if target_position == NO_TARGET:
		return
	
	var velocity_vector : Vector2 = Vector2(target_position - player_marker.position).normalized()
	var distance_to_target = player_marker.position.distance_to(target_position)
	var resources = ResourceManager.get_resources()

	var rations = resources[Constants.RATIONS]
	var energy = resources[Constants.ENERGY]
	var ox = resources[Constants.OXEN]

	if rations <= 0 or energy <= 0 or ox <= 0:
		# Stop the player marker
		player_marker.velocity = Vector2.ZERO
		player_marker.target_position = NO_TARGET

		var timer = get_tree().create_timer(0.6)

		var crnt_instance = target_marker_instance
		timer.connect("timeout", (func() -> void:
			if target_marker_instance != null and target_marker_instance == crnt_instance:
				# If a target marker already exists, remove it
				map_viewport.remove_child(target_marker_instance)
				target_marker_instance.queue_free()
				target_marker_instance = null
		))

		print("Out of resources!")
		return


	# @TODO: Separate tick timer for each resource
	if tick_timer.is_stopped():
		tick_timer.start()


		# Decrease resources
		ResourceManager.modify_resource(Constants.RATIONS, -4)
		ResourceManager.modify_resource(Constants.ENERGY, -2)

		produce_random_event()
	
	# If the distance is less than a threshold, stop moving
	if distance_to_target < Constants.MAP_SNAP_DISTANCE and \
		player_marker.velocity != Vector2.ZERO:
		# Stop the player marker
		
		player_marker.velocity = Vector2.ZERO
		player_marker.position = target_position

		player_marker.target_position = NO_TARGET
		
		target_marker_instance.queue_free()

		return

	player_marker.velocity = velocity_vector * player_marker.speed
	
	player_marker.move_and_slide()


func on_map_clicked() -> void:
	
	var local_mouse_position = map_viewport_container.get_local_mouse_position()

	# Move the player sprite to the clicked position
	player_marker.target_position = local_mouse_position
	
	player_sprite.stop()
	player_sprite.play("blink")

	# Show target destination

	if target_marker_instance != null:
		# If a target marker already exists, remove it
		map_viewport.remove_child(target_marker_instance)
		target_marker_instance.queue_free()


	target_marker_instance = target_marker.instantiate()
	target_marker_instance.position = local_mouse_position	
	map_viewport.add_child(target_marker_instance)

	map_viewport.move_child(target_marker_instance, 1) # Make sure the player sprite is on top of the target marker


func produce_random_event() -> void:

	var message : RichTextLabel = RichTextLabel.new()
	message.theme = message_log_theme
	message.bbcode_enabled = true 
	message.fit_content = true

	var num = randi() % 5

	if num == 1:
		message.text = "> Ox: 'The stock market is going down soon. Trust. Moo. Not financial advice.'"
	elif num == 2:
		message.text = "> Ox: 'The stock market is going up soon. Trust. Moo. Not financial advice.'"
	elif num == 3:
		message.text = "> Player: 'We are trapped in the belly of this horrible machine. And the machine is bleeding to death.'"
	elif num == 4:
		message.text = "> Player: 'The car's on fire and there's no driver at the wheel.'"
	else:
		message.text = "> Ox: 'For sure it's the valley of death.'"

	message_log_container.add_child(message)

	await get_tree().process_frame
	
	message_log.scroll_vertical = int(message_log.get_v_scroll_bar().max_value)



func is_within_viewport(pos: Vector2) -> bool:
	# Check if the position is within the bounds of the map
	return map_viewport_container.global_position.x <= pos.x and \
			pos.x <= map_viewport_container.global_position.x + map_viewport.size.x and \
			map_viewport_container.global_position.y <= pos.y and \
			pos.y <= map_viewport_container.global_position.y + map_viewport.size.y
