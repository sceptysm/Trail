extends CharacterBody2D


class_name MapPlayerMarker


@export var speed : float = 50.0


@onready var sprite : AnimatedSprite2D = $MarkerSprite

var target_position : Vector2 = Vector2(-1, -1)