extends KinematicBody2D

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

const FLASH_INTERVAL = 0.04
const SUPER_MASK = Color(3, 4, 4, 1)
const HURT_MASK = Color(0, 0, 0, 0)
const TERMINAL_VELOCITY = 1000

const RIGHT = -1
const LEFT = 1

var dead = false

var velocity = Vector2()
var acceleration = Vector2()

var flash_mask = SUPER_MASK

var invulnerable = false
var stamina = 100
var health = 6

var stun_count = 0
var is_stunned setget ,get_stunned

var dashing = false

var flash_time = 0
var flashing = false

var death_scene = preload("res://Player/Death/Death.tscn")

onready var iframe_timer = $IframeTimer
onready var dash = $Dash
onready var sprite = $Sprite
onready var hitbox = $CollisionShape2D
onready var bullet_spawn = $BulletSpawn
onready var animation = $'Sprite/AnimationPlayer'

signal hurt(health)

func _ready():
  InputMap.action_set_deadzone("ui_up", 0.2)
  InputMap.action_set_deadzone("ui_down", 0.2)
  InputMap.action_set_deadzone("ui_left", 0.2)
  InputMap.action_set_deadzone("ui_right", 0.2)

  iframe_timer.connect("timeout", self, "_on_Iframe_timer_timeout")
  dash.connect("tween_completed", self, "_on_Dash_tween_completed")

func _physics_process(delta):
  if dead:
    return

  handle_movement()

  velocity.y += acceleration.y * delta
  velocity.x += acceleration.x * delta

  if !dashing:
    velocity.x = min(velocity.x, TERMINAL_VELOCITY)
    velocity.x = max(velocity.x, -TERMINAL_VELOCITY)
    velocity.y = min(velocity.y, TERMINAL_VELOCITY)
    velocity.y = max(velocity.y, -TERMINAL_VELOCITY)

  velocity = move_and_slide(velocity, UP)

func _process(delta):
  if dead:
    return

  if !is_stunned && !dashing:
    animation.play("Idle")

  update_flash(delta)

func update_flash(delta):
  if invulnerable:
    flash_time -= delta
    if flash_time <= 0:
      flash_time = FLASH_INTERVAL
      flashing = !flashing
      if flashing:
        $Sprite.modulate = flash_mask
      else:
        $Sprite.modulate = Color(1, 1, 1, 1)

  else:
    flash_time = 0

    if flashing:
      $Sprite.modulate = Color(1, 1, 1, 1)
      flashing = false

func hurt(damage):
  if invulnerable && damage < 100:
    return

  Game.scene.reset_combo()
  Game.scene.shake(0.25)
  flash_mask = HURT_MASK
  set_iframes(0.5)

  health -= damage
  if health <= 0:
    health = 0
    die()
  else:
    $HurtSound.play()

  emit_signal("hurt", health)

func die():
  var death_node = death_scene.instance()
  Game.scene.particles.add_child(death_node)
  dead = true
  Game.scene.remove_child(self)
  Game.scene.game_over()

func handle_rotation():
  rotation = Vector2(
      Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
      Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
      ).angle() + \
      PI/2

func handle_movement():
  velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
  velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
  if velocity.length_squared() > 1:
    velocity = velocity.normalized()
  velocity *= TERMINAL_VELOCITY

func get_stunned():
  return stun_count > 0

func stun():
  acceleration = Vector2(0, 0)
  stun_count += 1

func unstun():
  stun_count -= 1

func set_iframes(duration = 0.5):
  if duration <= 0:
    return

  invulnerable = true
  iframe_timer.start(duration)

func _on_Iframe_timer_timeout():
  invulnerable = false

func _on_Dash_tween_completed(object, key):
  dashing = false

func _on_dash(speed, duration, target_speed):
  velocity.y = 0
  acceleration.y = 0

  dashing = true
  dash.interpolate_property(
      self,
      "velocity",
      speed,
      target_speed,
      duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  dash.start()
