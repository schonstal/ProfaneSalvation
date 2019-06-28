extends Node2D

onready var enemy = $Enemy
onready var animation = $Enemy/Sprite/AnimationPlayer

var shoot_timer:Timer

var started = false
var time = PI / 2
var original_position:Vector2
var shooting = false
var flying = true
var pattern = null

export var movement = Vector2(100, 100)
export var velocity = Vector2(0, 200)
export var move_rate = 1
export var shoot_time = 0.5

export(Resource) var bullet_pattern = preload("res://BulletPatterns/Lines.tscn")
export(Resource) var attack_sound_scene = preload("res://Enemies/BloodBat/AttackSound.tscn")

signal died

func _ready():
  shoot_timer = Timer.new()
  shoot_timer.set_name("ShootTimer")
  shoot_timer.wait_time = PI / move_rate
  shoot_timer.one_shot = true
  shoot_timer.start()
  add_child(shoot_timer)

  shoot_timer.connect("timeout", self, "_on_ShootTimer_timeout")
  animation.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

  enemy.connect("died", self, "_on_Enemy_died")
  original_position = position

func _process(delta):
  if flying:
    time += delta
    original_position += velocity * delta

  position.x = original_position.x + (sin(time * move_rate) + 1) * movement.x
  position.y = original_position.y + abs(cos(time * move_rate)) * movement.y

  if enemy.global_position.y > 1120:
    die()

func die():
  emit_signal("died")
  queue_free()

func _on_Enemy_died():
  die()

func _on_ShootTimer_timeout():
  shooting = !shooting

  if shooting:
    flying = false
    animation.play("AttackStart")
  else:
    animation.play("AttackEnd")
    if pattern != null:
      pattern.queue_free()


func _on_AnimationPlayer_animation_finished(name):
  if name == "AttackStart":
    Game.scene.sound.play_scene(attack_sound_scene, "bat_attack")
    animation.play("Attack")
    if position.y > 0:
      pattern = bullet_pattern.instance()
      call_deferred("add_child", pattern)

    shoot_timer.start(shoot_time)

  if name == "AttackEnd":
    flying = true
    animation.play("Fly")
    shoot_timer.start(PI / move_rate)
