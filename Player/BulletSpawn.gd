extends Node2D

var bullet_scene = preload("res://Player/Projectiles/Projectile.tscn")

func _process(delta):
  if Input.is_action_pressed("attack"):
    var bullet = bullet_scene.instance()

    Game.scene.projectiles.add_child(bullet)

    bullet.global_position = global_position
