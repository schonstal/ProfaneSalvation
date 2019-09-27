extends Node2D

export(Array, Resource) var phases = [
    preload("res://Enemies/RedLord/AttackPatterns/TwistShoot/TwistShoot.tscn"),
    preload("res://Enemies/RedLord/AttackPatterns/MoveShoot/MoveShoot.tscn"),
    preload("res://Enemies/RedLord/AttackPatterns/MoveShoot/MoveShoot.tscn"),
    preload("res://Enemies/RedLord/AttackPatterns/MoveShoot/MoveShoot.tscn")
  ]

export var phase_transition_time = 2.0

var active_pattern = null
var phase = 0
var active = true
var wait_timer:Timer

onready var red_lord = $'..'
onready var chains = $Chains

func _ready():
  EventBus.connect("boss_pattern_complete", self, "_on_boss_pattern_complete")
  EventBus.connect("boss_hurt", self, "_on_boss_hurt")

  red_lord.connect("fade_in_completed", self, "_on_RedLord_fade_in_completed")
  red_lord.connect("fade_out_completed", self, "_on_RedLord_fade_out_completed")

  wait_timer = Timer.new()
  wait_timer.set_name("WaitTimer")
  wait_timer.wait_time = phase_transition_time
  wait_timer.one_shot = true
  add_child(wait_timer)

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")
  chains.shoot()

func spawn_pattern():
  if active_pattern != null && is_instance_valid(active_pattern):
    active_pattern.queue_free()

  active_pattern = phases[phase].instance()
  red_lord.call_deferred("add_child", active_pattern)

func change_phase(index):
  if active_pattern != null && is_instance_valid(active_pattern):
    active_pattern.queue_free()

  EventBus.emit_signal("clear_projectiles")
  chains.shoot()
  active = false
  phase = index
  red_lord.fade_out()

func _on_boss_pattern_complete():
  if active:
    spawn_pattern()

func _on_boss_hurt(health):
  var percent = float(health) / red_lord.max_health

  if percent < 0.25 && phase < 3:
    change_phase(3)

  if percent < 0.50 && phase < 2:
    change_phase(2)

  if percent < 0.75 && phase < 1:
    change_phase(1)

func _on_RedLord_fade_in_completed():
  active = true
  spawn_pattern()

func _on_RedLord_fade_out_completed():
  wait_timer.start(phase_transition_time)
  if phase == 1:
    red_lord.global_position = Vector2(1920 / 2 - 200, 1080 / 2 - 200)
  if phase == 2:
    red_lord.global_position = Vector2(1920 / 2 + 200, 1080 / 2 - 200)
  elif phase == 3:
    red_lord.global_position = Vector2(1920 / 2, 1080 / 2 - 200)

func _on_WaitTimer_timeout():
  red_lord.fade_in()
