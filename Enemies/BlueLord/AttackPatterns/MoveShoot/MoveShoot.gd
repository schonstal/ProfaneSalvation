extends Node2D

@onready var blue_lord = $'..'

var wait_timer:Timer
var shoot_timer:Timer

@export var wait_time = 0.25
@export var bullet_count = 18
@export var distance = 50
@export var offset_increment = 0.1
@export var radius = 50.0
@export var bullet_speed = 100
@export var center = Vector2(1920 / 2, 1080 / 2 - 200)
@export var spawn_offset = Vector2(0, -82)
@export var upgrade_count = 6

var offset = 0.0
var shots = 0
var max_shots = 2
var shoot_time = 0.02
var count = 0
var speed_increment = 300

@export var blue_bullet_scene: Resource = preload("res://Projectiles/BlueFireball/EnemyFireball.tscn")
@export var purple_bullet_scene: Resource = preload("res://Projectiles/PitLordFireball/PitLordFireball.tscn")
@export var red_bullet_scene: Resource = preload("res://Projectiles/BatFireball/BatFireball.tscn")

var strong_bullet_scenes = [blue_bullet_scene, purple_bullet_scene, red_bullet_scene]
var weak_bullet_scenes = [blue_bullet_scene, purple_bullet_scene]
var bullet_scenes = [blue_bullet_scene]

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("WaitTimer")
  wait_timer.wait_time = wait_time
  wait_timer.one_shot = true
  wait_timer.start()
  add_child(wait_timer)

  shoot_timer = Timer.new()
  shoot_timer.set_name("ShootTimer")
  shoot_timer.wait_time = shoot_time
  shoot_timer.one_shot = true
  add_child(shoot_timer)

  wait_timer.connect("timeout", Callable(self, "_on_WaitTimer_timeout"))
  shoot_timer.connect("timeout", Callable(self, "_on_ShootTimer_timeout"))
  blue_lord.connect("move_completed", Callable(self, "_on_BlueLord_move_completed"))

func _on_WaitTimer_timeout():
  var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
  direction = direction.normalized()

  blue_lord.move_to(center + distance * direction, 1)

func _on_BlueLord_move_completed():
  blue_lord.start_attack()
  shots = 0
  shoot()

func _on_ShootTimer_timeout():
  shots += 1
  if shots < max_shots:
    shoot()
  else:
    count += 1
    if count >= 8:
      bullet_scenes = strong_bullet_scenes
      speed_increment = 100
      max_shots = 6
    elif count >= 4:
      bullet_scenes = weak_bullet_scenes
      speed_increment = 200
      max_shots = 4
    wait_timer.start()

func shoot():
  offset += offset_increment * TAU
  var speed = bullet_speed

  Util.spawn_full_circle({
      "position": global_position + spawn_offset,
      "scene": bullet_scenes[shots % bullet_scenes.size()],
      "count": bullet_count,
      "radius": radius,
      "speed": bullet_speed,
      "rotation": offset,
      "acceleration": 50 + shots * speed_increment
    })

  shoot_timer.start()
