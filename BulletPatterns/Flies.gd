extends Node2D

export var spawn_count = 6
export var bullet_speed = 250
export var spawn_time = 0.1

export(Resource) var bullet_scene = preload("res://Projectiles/Fly/Fly.tscn")

var spawn_timer:Timer

func _ready():
  for i in range(0, spawn_count):
    var bullet = bullet_scene.instance()
    Game.scene.projectiles.call_deferred("add_child", bullet)
    bullet.global_position = global_position + Vector2(
        cos(TAU * i / spawn_count),
        sin(TAU * i / spawn_count)
    ) * rand_range(0, 30)

  queue_free()
