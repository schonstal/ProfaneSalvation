tool
extends Node2D

onready var bar = $Bar
onready var back = $Back
onready var max_amount = 100

onready var container = $Container

export var bar_length = 0

var active = false
var percent = 1.0

func _ready():
  if Engine.editor_hint:
    return

  EventBus.connect("boss_hurt", self, "_on_boss_hurt")

func _process(delta):
  bar.rect_size.y = percent * (bar_length + 50)
  back.rect_size = bar.rect_size
  container.length = bar_length

func deactivate(flash = false):
  bar.margin_top = bar.margin_bottom
  active = false

func update_bar(amount):
  percent = float(amount) / max_amount

func _on_boss_hurt(health):
  update_bar(health)
