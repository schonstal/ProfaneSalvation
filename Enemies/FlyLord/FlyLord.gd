extends Node2D

onready var enemy = $Enemy
onready var animation = $Enemy/Sprite/AnimationPlayer

var shoot_timer:Timer

var started = false
var pattern = null

export var velocity = Vector2(0, 0)
export var acceleration = Vector2(0, 0)
export var shoot_time = 2
export var shoot_immediately = false

export(Resource) var bullet_pattern = preload("res://BulletPatterns/Flies.tscn")
export(Resource) var attack_sound_scene = preload("res://Enemies/FlyLord/AttackSound.tscn")

signal died

func _ready():
  shoot_timer = Timer.new()
  shoot_timer.set_name("ShootTimer")
  if shoot_immediately:
    shoot_timer.wait_time = 0.01
  else:
    shoot_timer.wait_time = shoot_time
  shoot_timer.one_shot = true
  shoot_timer.start()
  add_child(shoot_timer)

  shoot_timer.connect("timeout", self, "_on_ShootTimer_timeout")
  animation.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

  enemy.connect("died", self, "_on_Enemy_died")

func _physics_process(delta):
  velocity += acceleration * delta
  global_position += velocity * delta

  if global_position.y > 1120:
    die()

  if global_position.y < -100:
    die()

  if global_position.x > 1920:
    die()

  if global_position.x < 0:
    die()

func die():
  emit_signal("died")
  queue_free()

func _on_Enemy_died():
  EventBus.emit_signal("enemy_died", enemy.wave_name, name)
  die()

func _on_ShootTimer_timeout():
  Game.scene.sound.play_scene(attack_sound_scene, "fly_attack")
  animation.play("AttackStart")
  shoot_timer.start(shoot_time)

func _on_AnimationPlayer_animation_finished(name):
  if name == "AttackStart":
    if position.y > 0:
      pattern = bullet_pattern.instance()
      call_deferred("add_child", pattern)
      animation.play("Attack")

  if name == "Attack":
    animation.play("Idle")
