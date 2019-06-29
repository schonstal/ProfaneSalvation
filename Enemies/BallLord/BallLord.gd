extends Node2D

onready var enemy = $Enemy

export var bullet_count = 12
export var speed = Vector2(0, 200)
export var bullet_speed = 500
export var angular_velocity = 0.5

var disable_bullets = false

signal died

export(Resource) var bullet_scene = preload("res://Enemies/Projectiles/Projectile.tscn")

func _ready():
  enemy.connect("died", self, "_on_Enemy_died")
  enemy.connect("body_entered", self, "_on_body_entered")
  enemy.velocity.y = speed.y
  enemy.velocity.x = speed.x
  EventBus.connect("chapter_complete", self, "_on_chapter_complete")

func _on_chapter_complete():
  disable_bullets = true

func _process(delta):
  enemy.rotation += PI * 2 * delta * angular_velocity

  if enemy.global_position.y > 1200:
    queue_free()

  if enemy.global_position.x < 0:
    queue_free()

  if enemy.global_position.x > 1920:
    queue_free()

func _on_Enemy_died():
  emit_signal("died")

  if disable_bullets:
    queue_free()
    return

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
  if body.has_method("hurt"):
    body.hurt(1)
