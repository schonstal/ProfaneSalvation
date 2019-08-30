extends Node2D

onready var pit_lord = $'..'

var wait_timer:Timer

export var wait_time = 0.25
export var bullet_count = 18
export var distance = 50
export var offset_increment = 0.1
export var radius = 30.0
export var bullet_speed = 250
export var center = Vector2(1920 / 2, 1080 / 2 - 200)

var offset = 0.0

export(Resource) var bullet_scene = preload("res://Projectiles/PitLordFireball/PitLordFireball.tscn")

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("SpawnTimer")
  wait_timer.wait_time = wait_time
  wait_timer.one_shot = true
  wait_timer.start()
  add_child(wait_timer)

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")
  pit_lord.connect("move_completed", self, "_on_PitLord_move_completed")

func _on_WaitTimer_timeout():
  var direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
  direction = direction.normalized()

  pit_lord.move_to(center + distance * direction, 1)

func _on_PitLord_move_completed():
  pit_lord.start_attack()
  shoot()

func shoot():
  wait_timer.start()
  offset += offset_increment * TAU

  EventBus.emit_signal("boss_pattern_complete")

  Util.spawn_full_circle({
      "position": global_position,
      "scene": bullet_scene,
      "count": bullet_count,
      "radius": radius,
      "speed": bullet_speed,
      "rotation": offset
    })
