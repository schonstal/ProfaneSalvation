extends Node2D

@onready var red_lord = $'..'

var wait_timer:Timer
var upgrade_timer:Timer

@onready var twist = $Twist
@onready var blue_twist = $BlueTwist
@onready var purple_twist = $PurpleTwist

@export var wait_time = 1.0
@export var upgrade_time = 6.0
@export var points = [
    Vector2(1920 / 2, 1080 / 2 - 300),
    Vector2(1920 / 2 - 200, 1080 / 2 - 200),
    Vector2(1920 / 2, 1080 / 2 - 300),
    Vector2(1920 / 2 + 200, 1080 / 2 - 200)
  ]
@export var offsets = [
    PI / 16,
    0,
    PI / 16,
    PI / 8
  ]

@export var aim = Vector2(1920 / 2, 1080 / 2 - 300)

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
  point_index += 1
  point_index %= points.size()

  var next_point = points[point_index]

  red_lord.move_to(next_point)

func _on_UpgradeTimer_timeout():
  blue_twist.active = true
  level += 1
  if level > 1:
    purple_twist.active = true
  else:
    upgrade_timer.start()

func _on_RedLord_move_completed():
  red_lord.start_attack()
  twist.offset = offsets[point_index]
  twist.shoot()
  wait_timer.start()
