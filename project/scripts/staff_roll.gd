class_name StaffRoll extends Node2D


@export var speed := 500.0


func _physics_process(delta: float) -> void:
	position.x -= speed * delta
