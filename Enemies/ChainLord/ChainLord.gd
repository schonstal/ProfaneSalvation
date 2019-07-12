extends Node2D

onready var enemy = $Enemy
onready var animation = $Enemy/Sprite/AnimationPlayer

signal died

func _ready():
  enemy.connect("died", self, "_on_Enemy_died")
  animation.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

func _process(delta):
  rotation += delta
  enemy.global_rotation = 0

  if enemy.global_position.y > 1200:
    queue_free()

  if enemy.global_position.x < 0:
    queue_free()

  if enemy.global_position.x > 1920:
    queue_free()

func _on_AnimationPlayer_animation_finished(name):
  if name == "Fade":
    emit_signal("died")
    queue_free()

func _on_Enemy_died():
  emit_signal("died")
  queue_free()
