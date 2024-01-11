extends Node2D

func _ready():
  Game.scene.player.damaged.connect(_on_Player_hurt)
  EventBus.health_collected.connect(_on_health_collected)

  var children = get_children()

  for i in range(0, Game.scene.player.max_health):
    children[i].visible = true
    if Game.scene.player.health <= i:
      children[i].deactivate()

func _on_Player_hurt(health):
  var pips = get_children()

  for i in range(health, pips.size()):
    pips[i].deactivate()

func _on_health_collected():
  var health = Game.scene.player.health

  var pips = get_children()
  for i in range(health, pips.size()):
    pips[i].deactivate()

  pips[health - 1].activate()

