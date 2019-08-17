extends Node2D

var spawn_timer:Timer

export var bullet_count = 24
export var offset_increment = 0.1
export var cluster_size = 6
export var bullet_speed = 250
export var spawn_time = 0.1

var started = false
var offset = 0
var cluster_count = 0
var spawn = true

export(Resource) var bullet_scene = preload("res://Projectiles/Projectile.tscn")

func _ready():
  spawn_timer = Timer.new()
  spawn_timer.set_name("SpawnTimer")
  spawn_timer.wait_time = spawn_time
  spawn_timer.start()
  add_child(spawn_timer)

  spawn_timer.connect("timeout", self, "_on_SpawnTimer_timeout")

func _on_SpawnTimer_timeout():
  if cluster_count >= cluster_size:
    cluster_count = 0
    spawn = !spawn

  cluster_count += 1

  if spawn:
    offset -= offset_increment * TAU
  else:
    offset += offset_increment * TAU

  for i in range(0, bullet_count):
    var bullet = bullet_scene.instance()
    Game.scene.projectiles.call_deferred("add_child", bullet)

    bullet.global_position = global_position + Vector2(
        cos(TAU * i / bullet_count + offset),
        sin(TAU * i / bullet_count + offset)
    ) * 30

    bullet.velocity = Vector2(
        cos(TAU * i / bullet_count + offset),
        sin(TAU * i / bullet_count + offset)
    ) * bullet_speed
