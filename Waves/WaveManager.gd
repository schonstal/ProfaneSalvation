extends Node2D

signal completed

func _process(delta):
  if Input.is_action_just_pressed("deflect"):
    get_children()[0].spawn()

func wave_complete():
  print("wave complete!")
