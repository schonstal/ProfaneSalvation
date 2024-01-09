extends Node2D

@onready var red_lord = $'..'

var wait_timer:Timer
var upgrade_timer:Timer

@onready var twist = $Twist
@onready var purple_twist = $PurpleTwist

@export var wait_time = 1.0
@export var upgrade_time = 6.0
@export var distance = 50

@export var center = Vector2(1920 / 2, 1080 / 2 - 300)

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("WaitTimer")
  wait_timer.wait_time = wait_time
  wait_timer.one_shot = true
  wait_timer.start()
  add_child(wait_timer)

  upgrade_timer = Timer.new()
  upgrade_timer.set_name("WaitTimer")
  upgrade_timer.wait_time = upgrade_time
  upgrade_timer.one_shot = true
  upgrade_timer.start()
  add_child(upgrade_timer)

  upgrade_timer.connect("timeout", Callable(self, "_on_UpgradeTimer_timeout"))
  wait_timer.connect("timeout", Callable(self, "_on_WaitTimer_timeout"))
  red_lord.connect("move_completed", Callable(self, "_on_RedLord_move_completed"))
  red_lord.start_attack()

func _on_WaitTimer_timeout():
  var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
  direction = direction.normalized()

  red_lord.move_to(center + distance * direction, 1)

func _on_UpgradeTimer_timeout():
  purple_twist.active = true

func _on_RedLord_move_completed():
  red_lord.start_attack()
  wait_timer.start()
