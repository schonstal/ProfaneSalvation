extends Node2D

var wait_timer:Timer

@export var bullet_count = 20
@export var bullet_speed = 500
var shots = 0

@onready var pit_lord = $'..'

@export var bullet_scene: Resource = preload("res://Projectiles/PitLordSword/Projectile.tscn")

func _ready():
  for i in range(0, bullet_count):
    call_deferred("_spawn_bullet", i)

  if pit_lord != null:
    EventBus.emit_signal("boss_pattern_complete")

  queue_free()

func _spawn_bullet(i):
  var bullet = bullet_scene.instantiate()
  Game.scene.projectiles.add_child(bullet)

  if i % 2 == 0:
    bullet.global_position.x = 1
    bullet.velocity.x = bullet_speed
  else:
    bullet.global_position.x = 1919
    bullet.velocity.x = -bullet_speed

  bullet.global_position.y = (float(i) / bullet_count) * 1080 + 20
  bullet.velocity.y = 0
