tool
extends Node2D

onready var flash_tween = $FlashTween
onready var grow_tween = $GrowTween
onready var shrink_tween = $ShrinkTween

onready var bar = $Bar
onready var back = $Back
onready var max_amount = 100

onready var container = $Container

export var bar_length = 0

var active = false
var percent = 0.0

func _ready():
  if Engine.editor_hint:
    return

  visible = false

  EventBus.connect("boss_hurt", self, "_on_boss_hurt")
  EventBus.connect("boss_start", self, "_on_boss_start")
  EventBus.connect("boss_defeated", self, "_on_boss_defeated")

func _process(_delta):
  var fill_length = bar_length + 50
  bar.rect_size.y = percent * fill_length
  back.rect_size.y = fill_length
  container.length = bar_length

func deactivate():
  bar.margin_top = bar.margin_bottom
  active = false

func update_bar(amount):
  percent = float(amount) / max_amount

func _on_boss_hurt(health):
  update_bar(health)

func _on_boss_start(max_health):
  visible = true
  percent = 1.0
  max_amount = max_health

  grow_tween.interpolate_property(
      self,
      "bar_length",
      0,
      max_health + 75,
      2,
      Tween.TRANS_QUAD,
      Tween.EASE_OUT)

  grow_tween.start()

  flash_tween.interpolate_property(
      self,
      "modulate",
      Color(10, 10, 10, 1),
      Color(1, 1, 1, 1),
      0.3,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  flash_tween.start()

func _on_boss_defeated():
  flash_tween.interpolate_property(
      self,
      "modulate",
      Color(10, 10, 10, 1),
      Color(1, 1, 1, 1),
      0.3,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  flash_tween.start()

  shrink_tween.interpolate_property(
      self,
      "bar_length",
      bar_length,
      0,
      1,
      Tween.TRANS_QUAD,
      Tween.EASE_OUT)

  shrink_tween.start()

