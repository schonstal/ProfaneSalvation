extends Node2D

@onready var red_lord = $'..'

var wait_timer:Timer
var upgrade_timer:Timer

@export var wait_time = 1.0
@export var upgrade_time = 6.0
@export var center = Vector2(1920 / 2, 1080 / 2 - 200)
@export var angular_velocity = 1.0
@export var radius = 50

@export var chains_scene: Resource = preload("res://Enemies/RedLord/AttackPatterns/TwistShoot/Chains.tscn")

var theta = 0

var point_index = 0
var level = 0

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("WaitTimer")
  wait_timer.wait_time = wait_time
  wait_timer.one_shot = true
  wait_timer.start()
  add_child(wait_timer)

  upgrade_timer = Timer.new()
  upgrade_timer.set_name("UpgradeTimer")
  upgrade_timer.wait_time = upgrade_time
  upgrade_timer.one_shot = true
  upgrade_timer.start()
  add_child(upgrade_timer)

  upgrade_timer.connect("timeout", Callable(self, "_on_UpgradeTimer_timeout"))
  wait_timer.connect("timeout", Callable(self, "_on_WaitTimer_timeout"))
  red_lord.connect("move_completed", Callable(self, "_on_RedLord_move_completed"))
  red_lord.start_attack()

func _process(delta):
  theta += delta * angular_velocity * TAU
  red_lord.global_position = center + Vector2(sin(theta), cos(theta)) * radius

func _on_WaitTimer_timeout():
  pass

func _on_UpgradeTimer_timeout():
  red_lord.start_attack()

  var chains = chains_scene.instantiate()
  call_deferred("add_child", chains)
  chains.position = Vector2(0, 0)

  upgrade_timer.start()

func _on_RedLord_move_completed():
  pass
