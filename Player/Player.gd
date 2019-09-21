extends KinematicBody2D

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

export var max_speed = 800
export var max_health = 3
export var max_mana = 2
export var halos_per_pip = 25
export var shoot_rate = 0.2
export var deflect_buffer_time = 0.2
export var flash_interval = 0.04

var dead = false

var velocity = Vector2()
var acceleration = Vector2()

var invulnerable = false
var health = max_health
var mana = 1
var halos = 0

var stun_count = 0
var is_stunned setget ,get_stunned

var flash_time = 0
var flashing = false
var attacking = false
var attack_toggled = false

var deflect_buffer = 0
var deflect_pressed = false
var deflecting = false

var shoot_time = 0

onready var iframe_timer = $IframeTimer
onready var sprite = $Sprite
onready var hitbox = $CollisionShape2D
onready var bullet_spawn = $BulletSpawn
onready var hit_indicator = $HitIndicator
onready var animation = $'Sprite/AnimationPlayer'
onready var wings_animation = $'Wings/AnimationPlayer'
onready var muzzle_flare = $MuzzleFlare
onready var shoot_sound = $ShootSound
onready var shield_failure_sound = $ShieldFailure
onready var shield_full_sound = $ShieldFull
onready var laser = $Laser

var death_scene = preload("res://Player/Death/Death.tscn")
var bullet_scene = preload("res://Projectiles/AngelSword/AngelSword.tscn")

signal hurt(health)
signal mana_spent(mana)

func _ready():
  InputMap.action_set_deadzone("ui_up", 0.2)
  InputMap.action_set_deadzone("ui_down", 0.2)
  InputMap.action_set_deadzone("ui_left", 0.2)
  InputMap.action_set_deadzone("ui_right", 0.2)

  EventBus.connect("halo_collected", self, "_on_halo_collected")
  EventBus.connect("health_collected", self, "_on_health_collected")

  iframe_timer.connect("timeout", self, "_on_Iframe_timer_timeout")
  animation.connect("animation_finished", self, "_on_SpriteAnimationPlayer_finished")
  laser.connect("attack_finished", self, "_on_Laser_attack_finished")

func _physics_process(delta):
  if dead:
    return

  handle_movement()

  velocity.y += acceleration.y * delta
  velocity.x += acceleration.x * delta
  velocity.x = min(velocity.x, max_speed)
  velocity.x = max(velocity.x, -max_speed)
  velocity.y = min(velocity.y, max_speed)
  velocity.y = max(velocity.y, -max_speed)

  velocity = move_and_slide(velocity, UP)

func _process(delta):
  if dead:
    return

  if Input.is_action_just_pressed("attack_toggle"):
    attack_toggled = !attack_toggled

  shoot_time += delta

  handle_attack()
  handle_defend(delta)

  if !is_stunned && !attacking:
    animation.play("Idle")
    wings_animation.play("Idle")

  update_flash(delta)

func update_flash(delta):
  if invulnerable:
    flash_time -= delta
    if flash_time <= 0:
      flash_time = flash_interval
      flashing = !flashing
      if flashing:
        $Sprite.modulate = Color(1, 1, 1, 0.1)
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

  EventBus.emit_signal("clear_projectiles")
  Game.scene.shake(0.25)
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

func can_shoot():
  return !deflecting

func handle_defend(delta):
  deflect_buffer += delta

  if Input.is_action_just_pressed("deflect"):
    deflect_pressed = true
    deflect_buffer = 0

  if deflect_pressed && deflect_buffer < deflect_buffer_time && !deflecting:
    if mana > 0:
      mana -= 1
      emit_signal("mana_spent", mana)
      deflect_pressed = false
      EventBus.emit_signal("player_defend")
      deflecting = true
    else:
      shield_failure_sound.play()
      EventBus.emit_signal("shield_failure")

func handle_attack():
  if !attacking && _attack_pressed():
    attacking = true
    animation.play("ShootStartup")

func handle_movement():
  velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
  velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
  if velocity.length_squared() > 1:
    velocity = velocity.normalized()

  if attacking:
    velocity *= max_speed / 2
  else:
    velocity *= max_speed

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


var off = false
func shoot():
  if !can_shoot():
    return

  if Game.scene.gun_level == 0:
    spawn_bullet(Vector2(0, 0))
  elif Game.scene.gun_level == 1:
    spawn_bullet(Vector2(0, -20))
    spawn_bullet(Vector2(30, 0))
    spawn_bullet(Vector2(-30, 0))
  else:
    spawn_bullet(Vector2(0, -40))
    spawn_bullet(Vector2(20, -20))
    spawn_bullet(Vector2(-20, -20))
    spawn_bullet(Vector2(40, 0))
    spawn_bullet(Vector2(-40, 0))

  shoot_time = 0

  muzzle_flare.shoot()
  shoot_sound.play()

func spawn_bullet(offset):
  var bullet = bullet_scene.instance()
  Game.scene.projectiles.call_deferred("add_child", bullet)
  bullet.global_position = bullet_spawn.global_position + offset
  bullet.rotation = -PI / 2

func _attack_pressed():
  var button = Input.is_action_pressed("attack")

  if attack_toggled:
    return !button
  else:
    return button

func _on_health_collected():
  if health < max_health:
    health += 1

  Overlay.fade(Color(1, 0.75, 0.75, 0.6), Color(1, 0.75, 0.75, 0), 0.3)

func _on_halo_collected():
  if mana >= max_mana:
    halos = 0
    return

  halos += 1
  if halos >= halos_per_pip:
    halos = 0
    mana += 1
    shield_full_sound.play()

func _on_Iframe_timer_timeout():
  invulnerable = false

func _on_SpriteAnimationPlayer_finished(name):
  if name == "ShootStartup":
    animation.play("Shoot")
    hit_indicator.visible = false
  elif name == "Shoot":
    shoot()

    if _attack_pressed():
      animation.play("Shoot")
    else:
      animation.play("ShootRecover")
      hit_indicator.visible = true
  elif name == "ShootRecover":
    attacking = false

func _on_Laser_attack_finished():
  deflecting = false
