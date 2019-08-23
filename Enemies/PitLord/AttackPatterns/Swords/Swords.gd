extends Node2D

onready var pit_lord = $'..'

var wait_timer:Timer

export var wait_time = 0.75
export var bullet_count = 7
export var distance = 50
export var offset_increment = 0.1
export var radius = 220.0
export var bullet_speed = 500

var offset = 0.0
var shots = 0
var max_shots = 6

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
  if shots >= max_shots:
    EventBus.emit_signal("boss_pattern_complete")
    return

  pit_lord.move_to(Vector2(Game.scene.player.position.x, pit_lord.position.y))

func _on_PitLord_move_completed():
  pit_lord.start_attack()
  shoot()

func shoot():
  wait_timer.start()
  offset += offset_increment * TAU

  shots += 1
  for i in range(0, bullet_count):
    var bullet = bullet_scene.instance()
    bullet.global_position = global_position
    bullet.offset = (i + 1.5) * -PI / (bullet_count + 2)
    bullet.delay = i * 0.025
    bullet.radius = radius
    bullet.speed = bullet_speed
    bullet.duration = (bullet_count - i) * 0.025 + 0.2

    Game.scene.projectiles.call_deferred("add_child", bullet)
