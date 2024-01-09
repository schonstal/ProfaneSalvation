extends Node2D

@export var spawn_count = 6
@export var offset_increment = 0.1
@export var bullet_speed = 250
@export var bullet_acceleration = 0
@export var spawn_time = 0.1
@export var duration = 0.0
@export var rotate = true
@export var radius = 30
@export var arc = TAU
@export var offset = 0.0
@export var speed_increment = 0
@export var active = true
@export var stacks = 1
@export var stack_acceleration = 50
@export var stack_speed = 0

@export var bullet_scene: Resource = preload("res://Projectiles/Projectile.tscn")

var spawn_timer:Timer
var duration_timer:Timer

signal shot

func _ready():
  if duration > 0:
    duration_timer = Timer.new()
    duration_timer.set_name("DurationTimer")
    duration_timer.wait_time = duration
    duration_timer.one_shot = true
    duration_timer.start()
    add_child(duration_timer)

    duration_timer.connect("timeout", Callable(self, "_on_DurationTimer_timeout"))

  spawn_timer = Timer.new()
  spawn_timer.set_name("SpawnTimer")
  spawn_timer.wait_time = spawn_time
  spawn_timer.start()
  add_child(spawn_timer)

  spawn_timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))

  shoot()

func shoot():
  if !active:
    return

  for i in range(0, stacks):
    Util.spawn_full_circle({
        "position": global_position,
        "scene": bullet_scene,
        "count": spawn_count,
        "radius": radius,
        "speed": bullet_speed + i * stack_speed,
        "acceleration": bullet_acceleration + i * stack_acceleration,
        "rotation": offset,
        "arc": arc
      })

  bullet_speed += speed_increment

  if rotate:
    offset += offset_increment * TAU

  emit_signal("shot")

func _on_SpawnTimer_timeout():
  shoot()

func _on_DurationTimer_timeout():
  queue_free()
