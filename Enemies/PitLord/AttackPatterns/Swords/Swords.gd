extends Node2D

onready var pit_lord = $'..'

var wait_timer:Timer

export var wait_time = 1.0
export var bullet_count = 6
export var distance = 50
export var offset_increment = 0.1
export var radius = 150.0
export var bullet_speed = 500

var offset = 0.0

export(Resource) var bullet_scene = preload("res://Projectiles/PitLordSword/PitLordSword.tscn")

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
  pit_lord.move_to(Vector2(Game.scene.player.position.x, pit_lord.position.y))

func _on_PitLord_move_completed():
  shoot()

func shoot():
  wait_timer.start()
  offset += offset_increment * TAU

  for i in range(0, bullet_count):
    var bullet = bullet_scene.instance()
    bullet.global_position = global_position
    bullet.offset = i * -0.05 - 0.15
    bullet.delay = i * 0.1
    bullet.radius = radius
    bullet.speed = bullet_speed

    Game.scene.projectiles.call_deferred("add_child", bullet)
