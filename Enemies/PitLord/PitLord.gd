extends Node2D

onready var collision = $Enemy/CollisionShape2D
onready var appear_sound = $AppearSound
onready var disappear_sound = $DisappearSound
onready var attack_sound = $AttackSound
onready var idle_timer = $IdleTimer
onready var fade_tween = $FadeTween
onready var fade_in_tween = $FadeInTween
onready var move_tween = $MoveTween
onready var animation = $Enemy/Sprite/AnimationPlayer
onready var enemy = $Enemy

export var idle_time = 2.0
export var fade_duration = 0.3
export var one_shot = false

export var brightness = 1.5

signal move_completed

func _ready():
  move_tween.connect("tween_completed", self, "_on_MoveTween_tween_completed")
  fade_tween.connect("tween_completed", self, "_on_FadeTween_tween_completed")
  fade_in_tween.connect("tween_completed", self, "_on_FadeInTween_tween_completed")
  idle_timer.connect("timeout", self, "_on_IdleTimer_timeout")
  animation.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

  fade_in()

func _on_FadeTween_tween_completed(object, key):
  collision.disabled = true
  if one_shot:
    queue_free()

func _on_FadeInTween_tween_completed(object, key):
  animation.play("Attack")

func _on_IdleTimer_timeout():
  fade_out()
  # Spawn boss wave

func _on_AnimationPlayer_animation_finished(name):
  if name == "Attack":
    idle_timer.start(idle_time)
    animation.play("Idle")

func _on_MoveTween_tween_completed(object, key):
  emit_signal("move_completed")

func move_to(target, duration = 0.5):
  move_tween.stop_all()
  move_tween.interpolate_property(
      self,
      "position",
      position,
      target,
      duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)
  move_tween.start()

func fade_in():
  animation.play("Idle")
  collision.disabled = false
  appear_sound.play()
  fade_in_tween.interpolate_property(
      self,
      "modulate",
      Color(brightness, brightness, brightness, 0),
      Color(brightness, brightness, brightness, 1),
      fade_duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  fade_in_tween.start()

func fade_out():
  disappear_sound.play()
  fade_tween.interpolate_property(
      self,
      "modulate",
      Color(brightness, brightness, brightness, 1),
      Color(brightness, brightness, brightness, 0),
      fade_duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  fade_tween.start()

