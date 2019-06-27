extends KinematicBody2D

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

const FLASH_INTERVAL = 0.04
const SUPER_MASK = Color(3, 4, 4, 1)
const HURT_MASK = Color(0, 0, 0, 0)
const TERMINAL_VELOCITY = 800

const RIGHT = -1
const LEFT = 1

var dead = false

var velocity = Vector2()
var acceleration = Vector2()

var flash_mask = SUPER_MASK

var invulnerable = false
var stamina = 100
var health = 3

var stun_count = 0
var is_stunned setget ,get_stunned

var dashing = false

var flash_time = 0
var flashing = false
var attacking = false

var death_scene = preload("res://Player/Death/Death.tscn")

export var shoot_rate = 0.2
var shoot_time = 0

var bullet_scene = preload("res://Player/Projectiles/Projectile.tscn")

onready var iframe_timer = $IframeTimer
onready var dash = $Dash
onready var sprite = $Sprite
onready var hitbox = $CollisionShape2D
onready var bullet_spawn = $BulletSpawn
onready var hit_indicator = $HitIndicator
onready var animation = $'Sprite/AnimationPlayer'
onready var wings_animation = $'Wings/AnimationPlayer'
onready var shield = $Shield
onready var muzzle_flare = $MuzzleFlare
onready var shoot_sound = $ShootSound

var deflect_buffer = 0
export var deflect_buffer_time = 0.2
var deflect_pressed = false

signal hurt(health)

func _ready():
  InputMap.action_set_deadzone("ui_up", 0.2)
  InputMap.action_set_deadzone("ui_down", 0.2)
  InputMap.action_set_deadzone("ui_left", 0.2)
  InputMap.action_set_deadzone("ui_right", 0.2)

  iframe_timer.connect("timeout", self, "_on_Iframe_timer_timeout")
  dash.connect("tween_completed", self, "_on_Dash_tween_completed")
  animation.connect("animation_finished", self, "_on_SpriteAnimationPlayer_finished")

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

  shoot_time += delta

  handle_attack(delta)
  handle_defend(delta)

  if !is_stunned && !dashing && !attacking:
    animation.play("Idle")
    wings_animation.play("Idle")

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

  $Wings.modulate = $Sprite.modulate

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

  Overlay.fade(Color(1, 1, 1, 0.4), Color(1, 1, 1, 0), 0.3)

  emit_signal("hurt", health)

func die():
  var death_node = death_scene.instance()
  Game.scene.particles.add_child(death_node)
  dead = true
  Game.scene.remove_child(self)
  Game.scene.game_over()

func handle_defend(delta):
  deflect_buffer += delta

  if Input.is_action_just_pressed("deflect"):
    deflect_pressed = true
    deflect_buffer = 0

  if deflect_pressed && deflect_buffer < deflect_buffer_time:
    shield.deflect()
    deflect_pressed = false

func handle_attack(delta):
  if !attacking && Input.is_action_pressed("attack"):
    attacking = true
    animation.play("ShootStartup")

func handle_movement():
  velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
  velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
  if velocity.length_squared() > 1:
    velocity = velocity.normalized()

  if attacking:
    velocity *= TERMINAL_VELOCITY / 2
  else:
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

func _on_SpriteAnimationPlayer_finished(name):
  if name == "ShootStartup":
    animation.play("Shoot")
    hit_indicator.visible = false
  elif name == "Shoot":
    var bullet = bullet_scene.instance()
    Game.scene.projectiles.call_deferred("add_child", bullet)
    bullet.global_position = bullet_spawn.global_position
    bullet.rotation = -PI / 2
    shoot_time = 0
    muzzle_flare.shoot()
    shoot_sound.play()

    if Input.is_action_pressed("attack"):
      animation.play("Shoot")
    else:
      animation.play("ShootRecover")
      hit_indicator.visible = true
  elif name == "ShootRecover":
    attacking = false

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
