extends Node2D

onready var front = $Front
onready var back = $Back

export var angular_velocity = 200.0
var theta = 0

func _process(delta):
  theta += angular_velocity * delta * TAU
  front.rotation = theta
  back.rotation = -theta
