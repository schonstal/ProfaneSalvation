extends Node2D

@export var angular_velocity = 1.0

func _process(delta):
  rotation += TAU * delta * angular_velocity