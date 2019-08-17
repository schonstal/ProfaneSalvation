extends Node2D

onready var pit_lord = $'..'

var wait_timer:Timer

export var wait_time = 0.25
export var bullet_count = 12
export var distance = 300

export(Resource) var bullet_scene = preload("res://Projectiles/PitLordFireball/PitLordFireball.tscn")

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("SpawnTimer")
  wait_timer.wait_time = wait_time
  wait_timer.start()
  add_child(wait_timer)

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")
  pit_lord.connect("move_completed", self, "_on_PitLord_move_completed")

func _on_WaitTimer_timeout():
  var direction = Vector2(randf(), randf())
  direction = direction.normalized()

  pit_lord.move_to(pit_lord.position + distance * direction)

func _on_PitLord_move_completed():
  shoot()

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
