extends Control

onready var label = $Label

func _process(delta):
  if Game.scene.combo < Game.scene.MAX_COMBO:
    label.text = "%d" % Game.scene.combo
  else:
    label.text = "MAX"
