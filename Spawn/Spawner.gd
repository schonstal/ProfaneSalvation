extends Node2D

export var summon_time = 2.0
export var delay = 0.0
export(Resource) var spawn_scene

onready var summon_timer = $SummonTimer
onready var delay_timer = $DelayTimer
onready var summon_circle = $SummonCircle
onready var black_hole = $BlackHole
onready var black_hole_animation = $BlackHole/AnimationPlayer

var cleanup = false

func _ready():
  summon_timer.connect("timeout", self, "_on_SummonTimer_timeout")
  black_hole_animation.connect("animation_finished", self, "_on_BlackHole_animation_finished")

  if delay == 0:
    begin()
  else:
    delay_timer.connect("timeout", self, "_on_DelayTimer_timeout")
    delay_timer.start(delay)

  summon_circle.connect("fade_finished", self, "_on_SummonCircle_fade_finished")

func _on_DelayTimer_timeout():
  begin()

func begin():
  summon_circle.fade_in()
  summon_timer.start(summon_time)

func _on_SummonTimer_timeout():
  black_hole.visible = true
  black_hole_animation.play("Spawn")

func _on_BlackHole_animation_finished(name):
  if name == "Spawn":
    black_hole_animation.play("Fade")
    summon_circle.fade_out()

    if spawn_scene != null:
      var scene = spawn_scene.instance()
      scene.global_position = global_position
      Game.scene.current_wave.call_deferred('add_child', scene)

  if name == "Fade":
    queue_free()
