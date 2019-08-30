extends Node2D

export var spawn_count = 6
export var bullet_speed = 250
export var spawn_time = 0.1

export(Resource) var bullet_scene = preload("res://Projectiles/PitLordFireball/PitLordFireball.tscn")

func _ready():
  Util.spawn_full_circle({
    "position": global_position,
    "scene": bullet_scene,
    "count": spawn_count,
    "radius": 30,
    "speed": bullet_speed })

  queue_free()
