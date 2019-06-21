extends Node2D

onready var timer = $Timer
onready var enemy = $Enemy

export var bullet_count = 24
export var offset_increment = 0.1
export var cluster_size = 6

var started = false
var offset = 0
var cluster_count = 0
var spawn = true

export(Resource) var bullet_scene = preload("res://Enemies/Projectiles/PinkProjectile.tscn")

func _ready():
  timer.connect("timeout", self, "_on_Timer_timeout")
  enemy.connect("died", self, "_on_Enemy_died")

func _on_Timer_timeout():
  if cluster_count >= cluster_size:
    cluster_count = 0
    spawn = !spawn

  cluster_count += 1

  if spawn:
    offset -= offset_increment * PI * 2
  else:
    offset += offset_increment * PI * 2

  for i in range(0, bullet_count):
    var bullet = bullet_scene.instance()
    Game.scene.projectiles.call_deferred("add_child", bullet)
    bullet.global_position = enemy.global_position
    bullet.velocity = Vector2(
        cos(PI * 2 * i / bullet_count + offset),
        sin(PI * 2 * i / bullet_count + offset)
    ) * 300

func _on_Enemy_died():
  queue_free()
