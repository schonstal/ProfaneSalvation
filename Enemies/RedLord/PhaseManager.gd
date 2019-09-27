extends Node2D

export(Array, Resource) var phases = [
    preload("res://Enemies/RedLord/AttackPatterns/MoveShoot/MoveShoot.tscn"),
    preload("res://Enemies/BlueLord/AttackPatterns/SpiralBalls/SpiralBalls.tscn"),
    preload("res://Enemies/BlueLord/AttackPatterns/MoveTwist/MoveTwist.tscn"),
    preload("res://Enemies/BlueLord/AttackPatterns/BallSpin/BallSpin.tscn")
  ]

export var phase_transition_time = 1.0

var active_pattern = null
var phase = 0
var active = true
var wait_timer:Timer

onready var blue_lord = $'..'

func _ready():
  EventBus.connect("boss_pattern_complete", self, "_on_boss_pattern_complete")
  EventBus.connect("boss_hurt", self, "_on_boss_hurt")

  blue_lord.connect("fade_in_completed", self, "_on_BlueLord_fade_in_completed")
  blue_lord.connect("fade_out_completed", self, "_on_BlueLord_fade_out_completed")

  wait_timer = Timer.new()
  wait_timer.set_name("WaitTimer")
  wait_timer.wait_time = phase_transition_time
  wait_timer.one_shot = true
  add_child(wait_timer)

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")

func spawn_pattern():
  if active_pattern != null && is_instance_valid(active_pattern):
    active_pattern.queue_free()

  active_pattern = phases[phase].instance()
  blue_lord.call_deferred("add_child", active_pattern)

func change_phase(index):
  if active_pattern != null && is_instance_valid(active_pattern):
    active_pattern.queue_free()

  active = false
  phase = index
  blue_lord.fade_out()

func _on_boss_pattern_complete():
  if active:
    spawn_pattern()

func _on_boss_hurt(health):
  var percent = float(health) / blue_lord.max_health

  if percent < 0.25 && phase < 3:
    change_phase(3)

  if percent < 0.50 && phase < 2:
    change_phase(2)

  if percent < 0.75 && phase < 1:
    change_phase(1)

func _on_BlueLord_fade_in_completed():
  active = true
  spawn_pattern()

func _on_BlueLord_fade_out_completed():
  print("why")
  wait_timer.start(phase_transition_time)
  if phase == 1:
    print("1")
    blue_lord.global_position = Vector2(1920 / 2 - 200, 1080 / 2 - 200)
  if phase == 2:
    print("2")
    blue_lord.global_position = Vector2(1920 / 2 + 200, 1080 / 2 - 200)
  elif phase == 3:
    print("3")
    blue_lord.global_position = Vector2(1920 / 2, 1080 / 2 - 200)

func _on_WaitTimer_timeout():
  blue_lord.fade_in()
