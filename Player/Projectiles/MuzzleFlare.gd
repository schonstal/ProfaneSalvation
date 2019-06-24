extends Sprite

onready var animation = $AnimationPlayer

func _ready():
  animation.connect("animation_finished", self, "_on_AnimationPlayer_finished")

func shoot():
  visible = true
  animation.stop()
  animation.play("Shoot")

func _on_AnimationPlayer_finished(name):
  visible = false
