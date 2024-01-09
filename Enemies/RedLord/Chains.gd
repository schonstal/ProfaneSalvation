extends Node2D

var chain_scene = preload("res://Projectiles/Chain/Chain.tscn")
var chain_count = 3

func shoot():
  for i in range(0, chain_count):
    var y_position = i * 1080 / chain_count + randf_range(0, 25) + 100
    var x_position = i * 1320 / chain_count + randf_range(0, 25) + 500

    if i % 2 == 0:
      spawn_chain(0, y_position, PI / 2 + randf_range(-PI / 16, PI / 16))
    else:
      spawn_chain(1920, y_position, -PI / 2 - randf_range(-PI / 16, PI / 16))

    spawn_chain(x_position, -100, PI - randf_range(-PI / 8, PI / 8))

func spawn_chain(x, y, rotation):
  var chain = chain_scene.instantiate()
  chain.global_position.x = x
  chain.global_position.y = y
  chain.global_rotation = rotation
  chain.length = 1920
  chain.distance = 0
  chain.shoot_duration = 2.0
  chain.duration = 5.0
  Game.scene.projectiles.call_deferred("add_child", chain)
