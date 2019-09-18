extends Node2D

export(Array, Resource) var phase_one = [
    preload("res://Enemies/PitLord/AttackPatterns/SideSwords/SideSwords.tscn"),
    preload("res://Enemies/PitLord/AttackPatterns/Swords/Swords.tscn")
  ]

export(Array, Resource) var phase_two = [
    preload("res://Enemies/PitLord/AttackPatterns/TwistSwords/TwistSwords.tscn")
  ]

export(Array, Resource) var phase_three = [
    preload("res://Enemies/PitLord/AttackPatterns/SpinSkulls/SpinSkulls.tscn")
  ]

export var phase_transition_time = 1.0

var patterns = []

var active_pattern = null
var pattern_index = 0
var phase = 1
var active = true
var wait_timer:Timer

onready var pit_lord = $'..'

func _ready():
  EventBus.connect("boss_pattern_complete", self, "_on_boss_pattern_complete")
  EventBus.connect("boss_hurt", self, "_on_boss_hurt")

  pit_lord.connect("fade_in_completed", self, "_on_PitLord_fade_in_completed")
  pit_lord.connect("fade_out_completed", self, "_on_PitLord_fade_out_completed")

  wait_timer = Timer.new()
  wait_timer.set_name("WaitTimer")
  wait_timer.wait_time = phase_transition_time
  wait_timer.one_shot = true
  add_child(wait_timer)

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")

  patterns = phase_one

func spawn_pattern():
  if active_pattern != null && is_instance_valid(active_pattern):
    active_pattern.queue_free()

  active_pattern = next_pattern().instance()
  pit_lord.call_deferred("add_child", active_pattern)

func next_pattern():
  pattern_index += 1

  if pattern_index >= patterns.size():
    pattern_index = 0

  return patterns[pattern_index]

func change_phase(next_phase):
  if active_pattern != null && is_instance_valid(active_pattern):
    active_pattern.queue_free()
  # EventBus.emit_signal("clear_projectiles")

  active = false
  phase += 1
  patterns = next_phase
  pit_lord.fade_out()

func _on_boss_pattern_complete():
  if active:
    spawn_pattern()

func _on_boss_hurt(health):
  var percent = float(health) / pit_lord.max_health

  if percent < 0.25 && phase < 4:
    change_phase(phase_three)

  if percent < 0.5 && phase < 3:
    change_phase(phase_one)

  if percent < 0.75 && phase < 2:
    change_phase(phase_two)

func _on_PitLord_fade_in_completed():
  active = true
  spawn_pattern()

func _on_PitLord_fade_out_completed():
  wait_timer.start(phase_transition_time)
  if phase == 2:
    pit_lord.global_position = Vector2(1920 / 2, 1080 / 2 - 200)
  elif phase == 4:
    pit_lord.global_position = Vector2(1920 / 2 + 400, 1080 / 2)
  else:
    pit_lord.global_position = Vector2(Game.scene.player.position.x, 300)

func _on_WaitTimer_timeout():
  pit_lord.fade_in()
