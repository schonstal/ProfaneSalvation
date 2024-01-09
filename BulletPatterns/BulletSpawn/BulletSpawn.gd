extends Node2D

@export var delay = 0.0
@export var active_time = 3.0
@export var wait_time = 0.5

@onready var delay_timer = $DelayTimer
@onready var active_timer = $ActiveTimer
@onready var wait_timer = $WaitTimer

@onready var summon_circle = $SummonCircle
@onready var bullet_pattern = $BulletPattern

var finished = false

func _ready():
  active_timer.connect("timeout", Callable(self, "_on_ActiveTimer_timeout"))
  black_hole_animation.connect("animation_finished", Callable(self, "_on_BlackHole_animation_finished"))

  if delay == 0:
    begin()
  else:
    delay_timer.connect("timeout", Callable(self, "_on_DelayTimer_timeout"))
    delay_timer.start(delay)

  summon_circle.connect("fade_finished", Callable(self, "_on_SummonCircle_fade_finished"))

func _on_DelayTimer_timeout():
  begin()

func begin():
  summon_circle.fade_in()
  active_timer.start(active_time)

func _on_ActiveTimer_timeout():
  black_hole.visible = true
  black_hole_animation.play("Spawn")

func _on_SummonCircle_fade_finished():
  if finished:
    queue_free()

func _on_BlackHole_animation_finished(name):
  if name == "Spawn":
    black_hole_animation.play("Fade")

    if spawn_scene != null:
      var scene = spawn_scene.instantiate()
      scene.global_position = global_position
      Game.scene.current_wave.call_deferred('add_child', scene)

  # summon_circle.modulate = Color(100, 100, 100, 1)

  if name == "Fade":
    # summon_circle.modulate = Color(1, 1, 1, 1)
    summon_circle.fade_out()
    finished = true
    black_hole.queue_free()
