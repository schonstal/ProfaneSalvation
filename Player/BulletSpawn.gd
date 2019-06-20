extends Node2D

var bullet_scene = preload("res://Player/Projectiles/Projectile.tscn")

export var shoot_rate = 0.2
var shoot_time = 0

func _process(delta):
  shoot_time += delta

  if Input.is_action_pressed("attack"):
    if shoot_time > shoot_rate:
      var bullet = bullet_scene.instance()
      Game.scene.projectiles.add_child(bullet)
      bullet.global_position = global_position
      shoot_time = 0
