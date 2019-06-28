extends Area2D

onready var aim_timer = $AimTimer
onready var active_timer = $ActiveTimer
onready var animation = $Body/AnimationPlayer
onready var ring_animation = $Body/Ring/AnimationPlayer

export var aim_time = 0.5
export var active_time = 3.0

func _ready():
  aim_timer.connect("timeout", self, "_on_AimTimer_timeout")
  active_timer.connect("timeout", self, "_on_ActiveTimer_timeout")
  animation.connect("animation_finished", self, "_on_Body_animation_finished")

  connect("body_entered", self, "_on_body_enter")

  aim_timer.start(aim_time)

func _on_AimTimer_timeout():
  animation.play("Startup")
  ring_animation.play("Poof")

func _on_ActiveTimer_timeout():
  animation.play("Recovery")

func _on_Body_animation_finished(name):
  if name == "Startup":
    animation.play("Active")
    active_timer.start(active_time)

  if name == "Recovery":
    queue_free()

func _process(delta):
  if Game.scene != null && Game.scene.player != null:
    if overlaps_body(Game.scene.player):
      Game.scene.player.hurt(1)

# Kill particles
func hurt(damage):
  pass
