extends Node2D

export var radius = 50
export var offset = 0
export var speed = 600

var duration = 0.2
var delay = 0.0
var wait_time = 0.7
var wait_timer:Timer
var init_timer:Timer

var active = false
var direction = Vector2(0, 0)

var aim_time = 0
var aim_limit = 0.5

onready var projectile = $Projectile
onready var move_tween = $MoveTween
onready var fade_tween = $FadeTween
onready var animation = $Projectile/Sprite/AnimationPlayer

func _ready():
  modulate =  Color(1, 1, 1, 0)

  wait_timer = Timer.new()
  wait_timer.set_name("WaitTimer")
  wait_timer.wait_time = wait_time - delay
  wait_timer.one_shot = true
  wait_timer.start()
  add_child(wait_timer)

  if delay > 0:
    init_timer = Timer.new()
    init_timer.set_name("InitTimer")
    init_timer.wait_time = delay
    init_timer.one_shot = true
    init_timer.start()
    add_child(init_timer)

    init_timer.connect("timeout", self, "_on_InitTimer_timeout")
  else:
    start_tween()

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")
  projectile.connect("died", self, "_on_Projectile_died")

  direction =  Vector2(
      cos(offset),
      sin(offset)
    ) * -1

  projectile.velocity = direction * 0.00001

func start_tween():
  move_tween.interpolate_property(
      self,
      "position",
      position,
      position + Vector2(
        cos(offset),
        sin(offset)
      ) * radius,
      duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)
  move_tween.start()

  fade_tween.interpolate_property(
      self,
      "modulate",
      Color(1, 1, 1, 0),
      Color(1, 1, 1, 1),
      duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)
  fade_tween.start()

func _on_Projectile_died(explosion):
  active = false
  explosion.rotation = projectile.rotation - PI / 2

func _on_WaitTimer_timeout():
  if active:
    shoot()
  else:
    fade_tween.stop_all()
    fade_tween.interpolate_property(
        self,
        "modulate",
        Color(10, 10, 10, 1),
        Color(1, 1, 1, 1),
        0.2,
        Tween.TRANS_QUART,
        Tween.EASE_OUT)
    fade_tween.start()
    active = true
    wait_timer.start(0.2 + delay)

func _on_InitTimer_timeout():
  start_tween()

func shoot():
  animation.play("Spin")

  projectile.velocity = Vector2(
      cos(offset),
      sin(offset)
  ) * -speed

  projectile.velocity = direction * speed
