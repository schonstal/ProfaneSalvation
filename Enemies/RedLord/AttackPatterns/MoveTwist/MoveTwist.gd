extends Node2D

onready var blue_lord = $'..'

var wait_timer:Timer
var activate_timer:Timer

export var activate_time = 6.0
export var wait_time = 3.0
export var distance = 50
export var center = Vector2(1920 / 2 - 200, 1080 / 2 - 200)
export var spawn_offset = Vector2(0, -82)

var offset = 0.0

onready var flies = $Flies

export(Resource) var pattern_scene = preload("res://Enemies/BlueLord/AttackPatterns/MoveTwist/AcceleratingTwist.tscn")

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("WaitTimer")
  wait_timer.wait_time = wait_time
  wait_timer.one_shot = true
  wait_timer.start()
  add_child(wait_timer)

  activate_timer = Timer.new()
  activate_timer.set_name("WaitTimer")
  activate_timer.wait_time = activate_time
  activate_timer.one_shot = true
  activate_timer.start()
  add_child(activate_timer)

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")
  activate_timer.connect("timeout", self, "_on_ActivateTimer_timeout")
  blue_lord.connect("move_completed", self, "_on_BlueLord_move_completed")

func _on_WaitTimer_timeout():
  var direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
  direction = direction.normalized()

  blue_lord.move_to(center + distance * direction, 1)

func _on_ActivateTimer_timeout():
  flies.active = true

func _on_BlueLord_move_completed():
  blue_lord.start_attack()
  shoot()

func shoot():
  var pattern = pattern_scene.instance()
  call_deferred("add_child", pattern)
  wait_timer.start()
