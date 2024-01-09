extends Node2D

@export var despawn_chance = 0.3
@onready var wave = $'..'

func _ready():
  for ball in get_children():
    if randf() < despawn_chance:
      ball.queue_free()
      wave.enemy_count -= 1
