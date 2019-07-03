extends Node2D

export var spawn_count = 6
export var bullet_speed = 250
export var spawn_time = 0.1

export(Resource) var bullet_scene = preload("res://Projectiles/Projectile.tscn")

var spawn_timer:Timer

func _ready():
  spawn_timer = Timer.new()
  spawn_timer.set_name("SpawnTimer")
  spawn_timer.wait_time = spawn_time
  spawn_timer.start()
  add_child(spawn_timer)

  spawn_timer.connect("timeout", self, "_on_SpawnTimer_timeout")

func _on_SpawnTimer_timeout():
  for i in range(0, spawn_count):
    var bullet = bullet_scene.instance()
    Game.scene.projectiles.call_deferred("add_child", bullet)

    bullet.global_position = global_position + Vector2(
        cos(TAU * i / spawn_count),
        sin(TAU * i / spawn_count)
    ) * 30

    bullet.velocity = Vector2(
        cos(TAU * i / spawn_count),
        sin(TAU * i / spawn_count)
    ) * bullet_speed
