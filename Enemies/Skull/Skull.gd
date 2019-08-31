extends Node2D

export var bob_amount = 4
export var bob_frequency = 0.5
export var laser_active_time = 3.0
export var fade_out = true
export var shoot_time = 0.5
export var fade_in = true

onready var enemy = $Enemy
onready var laser_spawn = $Enemy/LaserSpawn
onready var animation = $Enemy/Sprite/AnimationPlayer
onready var shoot_timer = $ShootTimer

var attacking = false
var bob_time = 0

var laser_scene = preload("res://Projectiles/DopeLaser/DopeLaser.tscn")
var laser:Node
var laser_finished = false

export(Resource) var bullet_pattern = null

signal died

func _ready():
  enemy.connect("died", self, "_on_Enemy_died")
  animation.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
  shoot_timer.connect("timeout", self, "_on_ShootTimer_timeout")

  shoot_timer.start(shoot_time)

  if fade_in:
    animation.play("FadeIn")

  $Enemy/Placeholder.visible = false

func _process(delta):
  bob_time += delta * bob_frequency

  if !attacking:
    enemy.position.y = sin(bob_time * TAU) * bob_amount

  if attacking:
    enemy.position.y = randf()
    enemy.position.x = randf()

func _on_ShootTimer_timeout():
  if enemy.health <= 0:
    return

  attacking = true
  enemy.position.y = 0
  enemy.position.x = 0

  laser = laser_scene.instance()
  laser.global_position = laser_spawn.global_position
  laser.rotation = rotation
  laser.active_time = laser_active_time
  laser.enemy = self
  laser.connect("attack_finished", self, "_on_attack_finished")
  Game.scene.lasers.call_deferred("add_child", laser)

  if bullet_pattern != null:
    var pattern = bullet_pattern.instance()
    call_deferred("add_child", pattern)

  animation.play("Attack")

func _on_attack_finished():
  laser_finished = true

  if fade_out:
    animation.play("Fade")
  else:
    shoot_timer.start(shoot_time)

func _on_AnimationPlayer_animation_finished(name):
  if name == "Fade":
    emit_signal("died")
    queue_free()

func _on_Enemy_died():
  emit_signal("died")
  queue_free()
