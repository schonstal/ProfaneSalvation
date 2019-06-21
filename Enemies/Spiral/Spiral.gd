extends Node2D

onready var timer = $Timer
onready var enemy = $Enemy

export var bullet_count = 24
export var offset_increment = 0.1

var started = false
var offset = 0

export(Resource) var bullet_scene = preload("res://Enemies/Projectiles/PinkProjectile.tscn")

func _ready():
  timer.connect("timeout", self, "_on_Timer_timeout")

func _on_Timer_timeout():
  offset += offset_increment * PI * 2

  for i in range(0, bullet_count):
    var bullet = bullet_scene.instance()
    Game.scene.projectiles.call_deferred("add_child", bullet)
    bullet.global_position = enemy.global_position
    bullet.velocity = Vector2(
        cos(PI * 2 * i / bullet_count + offset),
        sin(PI * 2 * i / bullet_count + offset)
    ) * 300
