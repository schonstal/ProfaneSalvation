extends Node

onready var projectile = $'..'

export var speed = 200.0

var direction = Vector2(0,0)

func _ready():
  direction = Game.scene.player.global_position - projectile.global_position

func _process(delta):
  var target_direction = Game.scene.player.global_position - projectile.global_position
  target_direction.y = 500
  target_direction = target_direction.normalized()

  direction = lerp(direction, target_direction, 0.05)
  direction = direction.normalized()

  projectile.velocity = direction * speed
