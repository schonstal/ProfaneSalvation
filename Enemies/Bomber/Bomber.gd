extends Node2D

onready var tween = $Tween
onready var timer = $Timer
onready var enemy = $Enemy

export var bullet_count = 12

var started = false

var bullet_scene = preload("res://Enemies/Projectiles/Projectile.tscn")

func _ready():
  tween.connect("tween_completed", self, "_on_Tween_tween_completed")
  timer.connect("timeout", self, "_on_Timer_timeout")
  enemy.connect("died", self, "_on_Enemy_died")

  enemy.position.x = (randi() % 11) * 115 + 315

  enemy.velocity.y = 0
  enemy.acceleration.y = 0

  tween.interpolate_property(
      enemy,
      "position",
      enemy.position,
      Vector2(enemy.position.x, 150),
      0.5,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  tween.start()

func _on_Timer_timeout():
  tween.interpolate_property(
      enemy,
      "position",
      enemy.position,
      Vector2(enemy.position.x, 1200),
      2,
      Tween.TRANS_BACK,
      Tween.EASE_IN)

  tween.start()

func _on_Tween_tween_completed(object, key):
  enemy.velocity.x = 0
  enemy.velocity.y = 0

  if !started:
    timer.start()
    started = true
  else:
    queue_free()

func _on_Enemy_died():
  for i in range(0, bullet_count):
    var bullet = bullet_scene.instance()
    Game.scene.projectiles.call_deferred("add_child", bullet)
    bullet.global_position = enemy.global_position
    bullet.velocity = Vector2(
        cos(PI * 2 * i / bullet_count),
        sin(PI * 2 * i / bullet_count)
    ) * 1000

  queue_free()
