extends Node2D

func _ready():
  EventBus.connect("wave_completed", self, "_on_wave_completed")

func _process(delta):
  if Input.is_action_just_pressed("deflect"):
    get_children()[0].spawn()

func _on_wave_completed(name):
  print("we done here boys! ", name)
