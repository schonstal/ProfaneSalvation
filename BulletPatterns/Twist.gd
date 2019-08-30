extends Node2D

export var spawn_count = 6
export var offset_increment = 0.1
export var bullet_speed = 250
export var spawn_time = 0.1

var offset = 0

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
  offset += offset_increment * TAU

  Util.spawn_full_circle({
      "position": global_position,
      "scene": bullet_scene,
      "count": spawn_count,
      "radius": 30,
      "speed": bullet_speed,
      "rotation": offset
    })
