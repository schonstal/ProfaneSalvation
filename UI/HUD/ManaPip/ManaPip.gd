extends Node2D

onready var bar = $ColorRect
onready var max_amount = Game.scene.player.halos_per_pip

onready var shimmer = $Shimmer
onready var shimmer_animation = $Shimmer/AnimationPlayer

var bar_length = 0
var active = true

func _ready():
  bar_length = bar.margin_bottom - bar.margin_top
  shimmer_animation.connect("animation_finished", self, "_on_Shimmer_animation_finished")

func deactivate():
  bar.margin_top = bar.margin_bottom
  active = false

func activate():
  if active:
    return

  shimmer.visible = true
  shimmer_animation.play("Shimmer")
  bar.margin_top = bar.margin_bottom - bar_length
  active = true

func update_bar(amount):
  var percent = float(amount) / max_amount

  bar.margin_top = bar.margin_bottom - bar_length * percent

func _on_Shimmer_animation_finished(name):
  shimmer.visible = false
