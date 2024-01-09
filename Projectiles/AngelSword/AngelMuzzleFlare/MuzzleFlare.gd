extends Sprite2D

@onready var animation = $AnimationPlayer

func _ready():
  animation.connect("animation_finished", Callable(self, "_on_AnimationPlayer_finished"))

func shoot():
  visible = true
  animation.stop()
  animation.play("Shoot")

func _on_AnimationPlayer_finished(name):
  visible = false
