extends Node2D

export var pip_width = 47

func _ready():
  Game.scene.player.connect("hurt", self, "_on_Player_hurt")

func _on_Player_hurt(health):
  pass
