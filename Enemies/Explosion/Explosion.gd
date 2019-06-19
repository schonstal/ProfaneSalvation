extends Sprite

onready var animation = $AnimationPlayer

func _ready():
  animation.connect("animation_finished", self, "_on_Animation_finished")

func _on_Animation_finished(animation_name):
  # ~*`* YOU MUST FREE YOURSELF *`*~
  queue_free()
