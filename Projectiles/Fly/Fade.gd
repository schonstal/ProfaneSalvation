extends Node2D

onready var fade_tween = $FadeTween
onready var sprite = $'..'

func _ready():
  sprite.modulate = Color(1, 1, 1, 0)

  fade_tween.interpolate_property(
      sprite,
      "modulate",
      Color(1, 1, 1, 0),
      Color(1, 1, 1, 1),
      0.5,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  fade_tween.interpolate_property(
      sprite,
      "scale",
      Vector2(2, 2),
      Vector2(1, 1),
      0.5,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  fade_tween.start()
