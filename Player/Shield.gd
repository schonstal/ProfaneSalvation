extends Node2D

onready var sprite = $Sprite
onready var animation = $Sprite/AnimationPlayer
onready var area = $Area2D
onready var collision = $Area2D/CollisionShape2D
onready var buffer = $InputBuffer
onready var halo_sprite = $Halo/Halo
onready var fade_tween = $FadeTween
onready var reveal_tween = $FadeTween
onready var shield_timer = $ShieldTimer

var deflecting = false
var deflect_attempt = false

export var fade_duration = 0.5
export var active_time = 0.5

func _ready():
  area.connect("area_entered", self, "_on_Area2D_area_entered")
  animation.connect("animation_finished", self, "_on_SpriteAnimationPlayer_finished")
  buffer.connect("timeout", self, "_on_InputBuffer_timeout")
  fade_tween.connect("tween_completed", self, "_on_FadeTween_tween_completed")
  shield_timer.connect("timeout", self, "_on_ShieldTimer_timeout")

  halo_sprite.modulate = Color(1, 1, 1, 0)
  collision.disabled = true

func _process(delta):
  if !deflecting && deflect_attempt:
    animation.stop()
    animation.play("Deflect")
    collision.disabled = false
    deflecting = true
    sprite.visible = true
    halo_sprite.modulate = Color(1, 1, 1, 1)
    visible = true

func deflect():
  deflect_attempt = true
  buffer.start()

func _on_Area2D_area_entered(area):
  if area.has_method("deflect"):
    area.deflect()

func _on_SpriteAnimationPlayer_finished(name):
  sprite.visible = false
  shield_timer.start(active_time)

func _on_FadeTween_tween_completed(object, key):
  deflecting = false
  collision.disabled = true
  visible = false

func _on_InputBuffer_timeout():
  deflect_attempt = false

func _on_ShieldTimer_timeout():
  fade_tween.interpolate_property(
      halo_sprite,
      "modulate",
      Color(1, 1, 1, 1),
      Color(1, 1, 1, 0),
      fade_duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  fade_tween.start()

