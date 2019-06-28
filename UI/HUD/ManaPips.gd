extends Node2D

func _ready():
  Game.scene.player.connect("mana_spent", self, "_on_Player_mana_spent")

func _on_Player_mana_spent(mana):
  pass
