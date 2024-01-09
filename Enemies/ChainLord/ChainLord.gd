extends Node2D

@onready var enemy = $Enemy
@onready var animation = $Enemy/Sprite2D/AnimationPlayer

signal died

func _ready():
  enemy.connect("died", Callable(self, "_on_Enemy_died"))
  animation.connect("animation_finished", Callable(self, "_on_AnimationPlayer_animation_finished"))

func _process(delta):
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
  EventBus.emit_signal("enemy_died", enemy.wave_name, name)
  emit_signal("died")
  queue_free()
