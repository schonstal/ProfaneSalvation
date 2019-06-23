extends Node2D

func _ready():
  EventBus.connect("wave_completed", self, "_on_wave_completed")
  get_children()[0].spawn()

func _on_wave_completed(name):
  print("spawn")
  get_children()[0].spawn()
