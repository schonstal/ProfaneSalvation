extends Sprite2D

@onready var animation = $AnimationPlayer

func _ready():
  animation.connect("animation_finished", Callable(self, "_on_Animation_finished"))

func _on_Animation_finished(_animation_name):
  queue_free()
