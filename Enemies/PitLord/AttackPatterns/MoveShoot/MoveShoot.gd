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
  shoot()

func shoot():
  wait_timer.start()
  offset += offset_increment * TAU

  for i in range(0, bullet_count):
    var bullet = bullet_scene.instance()
    Game.scene.projectiles.call_deferred("add_child", bullet)

    bullet.global_position = global_position + Vector2(
        cos(TAU * i / bullet_count + offset),
        sin(TAU * i / bullet_count + offset)
    ) * radius

    bullet.velocity = Vector2(
        cos(TAU * i / bullet_count + offset),
        sin(TAU * i / bullet_count + offset)
    ) * bullet_speed
