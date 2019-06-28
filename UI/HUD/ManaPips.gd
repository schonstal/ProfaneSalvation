extends Node2D

func _ready():
  Game.scene.player.connect("mana_spent", self, "_on_Player_mana_spent")
  EventBus.connect("halo_collected", self, "_on_halo_collected")

  var children = get_children()

  for i in range(0, Game.scene.player.max_mana):
    print(i)
    children[i].visible = true
    if Game.scene.player.mana <= i:
      children[i].deactivate()

func _on_halo_collected():
  var children = get_children()

  for i in range(0, Game.scene.player.max_mana):
    if Game.scene.player.mana < i:
      children[i].deactivate()

  for i in range(0, Game.scene.player.mana):
    children[i].activate()

  if Game.scene.player.mana < Game.scene.player.max_mana:
    children[Game.scene.player.mana].update_bar(Game.scene.player.halos)

func _on_Player_mana_spent(mana):
  var children = get_children()
  children[mana].deactivate()
  children[Game.scene.player.mana].update_bar(Game.scene.player.halos)
  children[Game.scene.player.mana + 1].update_bar(0)
