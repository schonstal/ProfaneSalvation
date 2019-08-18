extends Node2D

export var radius = 50
export var offset = 0
export var speed = 600

var duration = 0.1
var delay = 0.0
var wait_time = 0.5
var wait_timer:Timer

var active = false
var direction = Vector2(0, 0)

var aim_time = 0
var aim_limit = 0.5

onready var projectile = $Projectile
onready var move_tween = $MoveTween

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("SpawnTimer")
  wait_timer.wait_time = wait_time
  wait_timer.one_shot = true
  wait_timer.start()
  add_child(wait_timer)

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")
  move_tween.connect("tween_completed", self, "_on_MoveTween_tween_completed")
  projectile.connect("died", self, "_on_Projectile_died")

  direction =  Vector2(
      cos(TAU * offset),
      sin(TAU * offset)
    ) * -1

  projectile.velocity = direction * 0.00001

  move_tween.interpolate_property(
      self,
      "position",
      position,
      position + Vector2(
        cos(TAU * offset),
        sin(TAU * offset)
      ) * radius,
      duration + delay,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)
  move_tween.start()

func _on_Projectile_died():
  active = false

func _on_WaitTimer_timeout():
  projectile.velocity = Vector2(
      cos(TAU * offset),
      sin(TAU * offset)
  ) * -speed

  projectile.velocity = direction * speed

  active = true

func _process(delta):
  if !active:
    return

