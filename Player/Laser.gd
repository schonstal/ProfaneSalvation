extends Node2D

var laser_scene = preload("res://Projectiles/AngelLaser/AngelLaser.tscn")

onready var player = $'..'

signal attack_finished

func _ready():
  EventBus.connect("player_defend", self, "_on_player_defend")

func _on_player_defend():
  var laser = laser_scene.instance()
  laser.player_laser = true
  laser.connect("attack_finished", self, "_on_attack_finished")
  call_deferred("add_child", laser)

func _on_attack_finished():
  emit_signal("attack_finished")
