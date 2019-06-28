extends Sprite

var active = true

onready var animation = $AnimationPlayer

func _ready():
  animation.play("Fill")
  animation.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

func activate():
  animation.play("Fill")
  active = true

func deactivate():
  if active:
    animation.play("Fade")
    active = false

func _on_AnimationPlayer_animation_finished(name):
  if name == "Fade":
    animation.play("Empty")

  if name == "Fill":
    animation.play("Full")
