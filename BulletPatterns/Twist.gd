extends Node2D

export var spawn_count = 6
export var offset_increment = 0.1
export var bullet_speed = 250
export var spawn_time = 0.1
export var duration = 0.0
export var rotate = true
export var radius = 30

var offset = 0

export(Resource) var bullet_scene = preload("res://Projectiles/Projectile.tscn")

var spawn_timer:Timer
var duration_timer:Timer

func _ready():
  if duration > 0:
    duration_timer = Timer.new()
    duration_timer.set_name("DurationTimer")
    duration_timer.wait_time = duration
    duration_timer.one_shot = true
    duration_timer.start()
    add_child(duration_timer)

    duration_timer.connect("timeout", self, "_on_DurationTimer_timeout")

  spawn_timer = Timer.new()
  spawn_timer.set_name("SpawnTimer")
  spawn_timer.wait_time = spawn_time
  spawn_timer.start()
  add_child(spawn_timer)

  spawn_timer.connect("timeout", self, "_on_SpawnTimer_timeout")

  shoot()

func shoot():
  Util.spawn_full_circle({
      "position": global_position,
      "scene": bullet_scene,
      "count": spawn_count,
      "radius": radius,
      "speed": bullet_speed,
      "rotation": offset
    })

  if rotate:
    offset += offset_increment * TAU

func _on_SpawnTimer_timeout():
  shoot()

func _on_DurationTimer_timeout():
  queue_free()
