extends Node

@export var time = 1.0
@export var amount = 10
@export var fps = 60

func shake():
  Game.scene.shake(time, fps, amount)
