extends Node2D

onready var bar = $ColorRect
onready var max_amount = Game.scene.player.halos_per_pip

var bar_length = 0

func _ready():
  bar_length = bar.margin_bottom - bar.margin_top
  bar.margin_top = bar.margin_bottom

func update_bar(amount):
  var percent = float(amount) / max_amount

  bar.margin_top = bar.margin_bottom - bar_length * percent
