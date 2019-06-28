extends Node2D

func _ready():
  Game.scene.player.connect("hurt", self, "_on_Player_hurt")

  var children = get_children()

  for i in range(0, Game.scene.player.max_health):
    children[i].visible = true
    if Game.scene.player.health <= i:
      children[i].deactivate()

func _on_Player_hurt(health):
  var pips = get_children()

  for i in range(health, pips.size()):
    pips[i].deactivate()
