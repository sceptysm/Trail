extends CharacterBody2D

class_name Player


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
const speed = 450.0


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("shoot"):
			print("Shooting")
		

# Set up a movement controller
func _physics_process(_delta: float) -> void:


	# Retrieve player input 
	var input_vector = Input.get_vector("left", "right", "up", "down")

	velocity = input_vector * speed

	
	# Update the sprite animation based on the input
	# left, right, up, down
	if input_vector.x < 0:
		sprite.play("left")
	elif input_vector.x > 0:
		sprite.play("right")
	elif input_vector.y < 0:
		sprite.play("up")
	elif input_vector.y > 0:
		sprite.play("down")
	else:
		sprite.stop()

	move_and_slide()

