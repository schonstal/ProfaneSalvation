extends Node2D

onready var red_lord = $'..'
onready var twist = $Twist
onready var blue_twist = $BlueTwist

var wait_timer:Timer
var upgrade_timer:Timer

export var wait_time = 6.0
export var upgrade_time = 6.0
export var center = Vector2(1920 / 2, 1080 / 2 - 200)
export var distance = 50

export(Resource) var chains_scene = preload("res://Enemies/RedLord/AttackPatterns/Inverted/Chains.tscn")

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

  upgrade_timer.connect("timeout", self, "_on_UpgradeTimer_timeout")
  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")
  red_lord.connect("move_completed", self, "_on_RedLord_move_completed")
  red_lord.start_attack()

  twist.global_position = center
  red_lord.global_position = center

func _process(delta):
  twist.global_position = center

func _on_WaitTimer_timeout():
  var chains = chains_scene.instance()
  call_deferred("add_child", chains)
  chains.position = Vector2(0, 0)
  wait_timer.start()

func _on_UpgradeTimer_timeout():
  blue_twist.active = true

func _on_RedLord_move_completed():
  pass
