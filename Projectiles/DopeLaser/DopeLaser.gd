extends Area2D

onready var aim_timer = $AimTimer
onready var active_timer = $ActiveTimer
onready var animation = $Body/AnimationPlayer
onready var ring_animation = $Body/Ring/AnimationPlayer

var enemy = null
var active = true
var player_laser = false

export var aim_time = 0.25
export var active_time = 3.0

export(Resource) var charge_up_sound = preload("res://Projectiles/DopeLaser/ChargeUpSound.tscn")
export(Resource) var shut_down_sound = preload("res://Projectiles/DopeLaser/ShutDownSound.tscn")

signal attack_finished

var active_bodies = []
var damage = 3
var time_per_hit = 0.05
var timer = 0

func _ready():
  aim_timer.connect("timeout", self, "_on_AimTimer_timeout")
  active_timer.connect("timeout", self, "_on_ActiveTimer_timeout")
  animation.connect("animation_finished", self, "_on_Body_animation_finished")

  connect("body_entered", self, "_on_body_entered")
  connect("area_entered", self, "_on_body_entered")

  connect("body_exited", self, "_on_body_exited")
  connect("area_exited", self, "_on_body_exited")

  if enemy != null:
    enemy.connect("died", self, "_on_enemy_died")

  aim_timer.start(aim_time)

func _on_AimTimer_timeout():
  Game.scene.sound.play_scene(charge_up_sound, "chargelaser")
  animation.play("Startup")
  ring_animation.play("Poof")

func _on_ActiveTimer_timeout():
  shut_down()

func _on_Body_animation_finished(name):
  if name == "Startup":
    $Wobble.play()
    animation.play("Active")
    active_timer.start(active_time)

  if name == "Recovery":
    emit_signal("attack_finished")
    queue_free()

func _on_enemy_died():
  shut_down()
  queue_free()

func shut_down():
  active = false
  Game.scene.sound.play_scene(shut_down_sound, "shutdownlaser")
  $Wobble.stop()
  animation.play("Recovery")

func _process(delta):
  if Game.scene != null && Game.scene.player != null:
    if overlaps_body(Game.scene.player):
      Game.scene.player.hurt(1)

  timer -= delta
  if timer < 0:
    for body in active_bodies:
      body.hurt(damage)
    timer = time_per_hit

# Kill particles
func hurt(_damage):
  pass

func _on_body_entered(body):
  if !player_laser:
    return

  if body.has_method("hurt"):
    body.hurt(damage)
    active_bodies.push_front(body)

func _on_body_exited(body):
  if !player_laser:
    return

  if body.has_method("hurt"):
    var index = active_bodies.find(body)
    if index > -1:
      active_bodies.remove(index)
