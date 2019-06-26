extends Node2D

export var summon_time = 2.0

onready var summon_timer = $SummonTimer
onready var summon_circle = $SummonCircle
onready var black_hole = $BlackHole
onready var black_hole_animation = $BlackHole/AnimationPlayer

var cleanup = false

func _ready():
  summon_timer.start(summon_time)
  summon_timer.connect("timeout", self, "_on_SummonTimer_timeout")
  black_hole_animation.connect("animation_finished", self, "_on_BlackHole_animation_finished")

  summon_circle.connect("fade_finished", self, "_on_SummonCircle_fade_finished")
  summon_circle.fade_in()

func _on_SummonTimer_timeout():
  black_hole.visible = true
  black_hole_animation.play("Spawn")

func _on_BlackHole_animation_finished(name):
  if name == "Spawn":
    black_hole_animation.play("Fade")
    print("spawning my boi")
    summon_circle.fade_out()
  if name == "Fade":
    queue_free()
