extends Node2D

onready var enemy = $Enemy

export var bullet_count = 12
export var speed = 600
export var bullet_speed = 500
export var angular_velocity = 0.5

signal died

export(Resource) var bullet_scene = preload("res://Enemies/Projectiles/Projectile.tscn")

func _ready():
  enemy.connect("died", self, "_on_Enemy_died")
  enemy.connect("body_entered", self, "_on_body_entered")
  enemy.velocity.y = speed

func _process(delta):
  enemy.rotation += PI * 2 * delta * angular_velocity

  if enemy.global_position.y > 1200:
    queue_free()

func _on_Enemy_died():
  emit_signal("died")

  for i in range(0, bullet_count):
    var bullet = bullet_scene.instance()
    Game.scene.projectiles.call_deferred("add_child", bullet)
    bullet.global_position = enemy.global_position + Vector2(
        cos(PI * 2 * i / bullet_count),
        sin(PI * 2 * i / bullet_count)
    ) * 40
    bullet.velocity = Vector2(
        cos(PI * 2 * i / bullet_count),
        sin(PI * 2 * i / bullet_count)
    ) * bullet_speed

  queue_free()

func _on_body_entered(body):
  print("hi")
  if body.has_method("hurt"):
    body.hurt(1)
