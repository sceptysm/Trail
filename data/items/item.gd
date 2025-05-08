extends Node2D



class_name Item


@export var resource_type : String
@export var resource_amount : int
@export var pickup_radius : Area2D



func _ready() -> void:
    pickup_radius.connect("body_entered", func(body): on_body_entered(body))


func on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        print("Player entered the pickup radius")
        # Call the function to add the resource to the player's inventory

        ResourceManager.modify_resource(resource_type, resource_amount)

        queue_free()  # Remove the item from the scene after pickup