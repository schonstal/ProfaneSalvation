extends Node2D

func _ready():
  Game.scene.player.connect("mana_spent", self, "_on_Player_mana_spent")
  EventBus.connect("halo_collected", self, "_on_halo_collected")

func _on_halo_collected():
  get_children()[0].update_bar(Game.scene.player.halos)

func _on_Player_mana_spent(mana):
  pass
