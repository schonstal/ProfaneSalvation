extends Node2D

var spawn_timer:Timer

@export var bullet_count = 24
@export var offset_increment = 0.1
@export var cluster_size = 6
@export var bullet_speed = 250
@export var spawn_time = 0.1

var started = false
var offset = 0
var cluster_count = 0
var spawn = true

@export var bullet_scene: Resource = preload("res://Projectiles/Projectile.tscn")

func _ready():
  spawn_timer = Timer.new()
  spawn_timer.set_name("SpawnTimer")
  spawn_timer.wait_time = spawn_time
  spawn_timer.start()
  add_child(spawn_timer)

  spawn_timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))

func _on_SpawnTimer_timeout():
  if cluster_count >= cluster_size:
    cluster_count = 0
    spawn = !spawn

  cluster_count += 1

  if spawn:
    offset -= offset_increment * TAU
  else:
    offset += offset_increment * TAU

  Util.spawn_full_circle({
      "position": global_position,
      "scene": bullet_scene,
      "count": bullet_count,
      "radius": 50,
      "speed": bullet_speed,
      "rotation": offset
    })
