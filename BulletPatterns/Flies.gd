extends Node2D

@export var spawn_count = 2
@export var bullet_speed = 250
@export var spawn_time = 0.1

@export var bullet_scene: Resource = preload("res://Projectiles/Fly/Fly.tscn")

var spawn_timer:Timer

func _ready():
  Util.spawn_full_circle({
      "position": global_position,
      "scene": bullet_scene,
      "count": spawn_count,
      "radius": 10 })

  queue_free()
