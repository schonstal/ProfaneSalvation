extends Node2D

@onready var enemy = $Enemy

@export var bullet_count = 12
@export var speed = Vector2(0, 200)
@export var bullet_speed = 500
@export var angular_velocity = 0.5

var velocity
var acceleration

var disable_bullets = false

signal died

@export var bullet_scene: Resource = preload("res://Projectiles/Projectile.tscn")

func _ready():
  # Make your APIs consistent, you dingus
  if velocity != null:
    speed = velocity

  enemy.connect("died", Callable(self, "_on_Enemy_died"))
  enemy.connect("body_entered", Callable(self, "_on_body_entered"))
  enemy.velocity.y = speed.y
  enemy.velocity.x = speed.x
  EventBus.connect("chapter_complete", Callable(self, "_on_chapter_complete"))

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
  die()

func _on_body_entered(body):
  if body.has_method("hurt"):
    body.hurt(1)
    die()

func die():
  emit_signal("died")

  if disable_bullets:
    queue_free()
    return

  Util.spawn_full_circle({
      "position": enemy.global_position,
      "scene": bullet_scene,
      "count": bullet_count,
      "radius": 40,
      "speed": bullet_speed
    })

  queue_free()
