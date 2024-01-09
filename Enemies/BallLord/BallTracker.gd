extends Node

@onready var projectile = $'..'

@export var speed = 200.0

var direction = Vector2(0,0)

func _ready():
  direction = Game.scene.player.global_position - projectile.global_position
  speed = randf_range(speed - 25, speed + 25)
  projectile.velocity = direction.normalized() * speed
