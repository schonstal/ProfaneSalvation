extends Control

onready var background = $Background
onready var fill_effect = $FillEffect
onready var fill = $Fill
onready var enemy = $'../Enemy'

onready var fill_tween = $FillTween
onready var tween_timer = $TweenTimer

var bar_length = 500
var percent = 100.0
var new_margin = 0.0

export var tween_time = 0.5

func _ready():
  enemy.connect("hurt", self, "_on_Enemy_hurt")
  tween_timer.connect("timeout", self, "_on_TweenTimer_timeout")

  bar_length = fill.margin_right - fill.margin_left

func _on_Enemy_hurt(health, max_health):
  percent = float(health) / max_health

  new_margin = bar_length * percent + fill.margin_left
  fill.margin_right = new_margin

  tween_timer.start()

func _on_TweenTimer_timeout():
  fill_tween.interpolate_property(
      fill_effect,
      "margin_right",
      fill_effect.margin_right,
      new_margin,
      tween_time,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)
  fill_tween.start()
