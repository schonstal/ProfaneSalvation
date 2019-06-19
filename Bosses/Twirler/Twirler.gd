extends Node

onready var parent = $'..'
onready var enemy = $'../Enemy'

var bullet_scene = preload("res://Enemies/Projectiles/Projectile.tscn")
onready var shoot_timer = $ShootTimer

export var frequency = Vector2(1, 1)
export var amplitude = Vector2(1, 1)
export var stun_time = 1.0

var theta = 0
var stunned = false
var stun_timer:Timer
var original_position = Vector2(0,0)

func _ready():
  shoot_timer.connect("timeout", self, "_on_ShootTimer_timeout")
  stun_timer = Timer.new()
  stun_timer.one_shot = true
  stun_timer.connect("timeout", self, "_on_StunTimer_timeout")
  stun_timer.set_name("StunTimer")
  add_child(stun_timer)

  enemy.connect("hurt", self, "_on_Enemy_hurt")
  enemy.connect("died", self, "_on_Enemy_died")
  original_position = enemy.position

func _process(delta):
  if is_instance_valid(enemy) && !stunned:
    theta += delta
    enemy.position.x = original_position.x + \
        sin(theta * frequency.x) * \
        amplitude.x

    enemy.position.y = original_position.y + \
        cos(theta * frequency.y) * \
        amplitude.y

func _on_Enemy_hurt(health, max_health):
  stunned = true
  stun_timer.start(stun_time)

func _on_StunTimer_timeout():
  stunned = false

func _on_Enemy_died():
  queue_free()

func _on_ShootTimer_timeout():
  if !stunned:
    var bullet = bullet_scene.instance()
    Game.scene.projectiles.add_child(bullet)
    bullet.global_position = enemy.global_position
