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

signal died

export(Resource) var bullet_scene = preload("res://Projectiles/Projectile.tscn")

func _ready():
  timer.connect("timeout", self, "_on_Timer_timeout")
  enemy.connect("died", self, "_on_Enemy_died")

func _on_Timer_timeout():
  if cluster_count >= cluster_size:
    cluster_count = 0
    spawn = !spawn

  cluster_count += 1

  if spawn:
    offset -= offset_increment * TAU
  else:
    offset += offset_increment * TAU

  Util.spawn_full_circle({
      "position": enemy.global_position,
      "scene": bullet_scene,
      "count": bullet_count,
      "radius": 30,
      "speed": 300,
      "rotation": offset
    })

func _on_Enemy_died():
  emit_signal("died")
  queue_free()
