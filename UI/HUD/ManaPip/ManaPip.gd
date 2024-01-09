extends Node2D

@onready var bar = $ColorRect
@onready var max_amount = Game.scene.player.halos_per_pip

@onready var shimmer = $Shimmer
@onready var shimmer_animation = $Shimmer/AnimationPlayer
@onready var frame = $Frame

var bar_length = 0
var active = false

func _ready():
  bar_length = bar.offset_bottom - bar.offset_top
  shimmer_animation.connect("animation_finished", Callable(self, "_on_Shimmer_animation_finished"))

func deactivate():
  bar.offset_top = bar.offset_bottom
  active = false

func activate():
  if active:
    return

  shimmer.visible = true
  shimmer_animation.play("Shimmer")
  frame.flash()
  bar.offset_top = bar.offset_bottom - bar_length
  active = true

func update_bar(amount):
  var percent = float(amount) / max_amount

  bar.offset_top = bar.offset_bottom - bar_length * percent

func _on_Shimmer_animation_finished(_name):
  shimmer.visible = false
