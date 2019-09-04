extends Area2D

const UP = Vector2(0, -1)

export var max_health = 2
export var points = 100
export var flash_time = 0.05
export var stun_time = 0.5
export var halos = 2
export var max_speed = Vector2(200, 200)
export var halo_force = 400

var alive = true
var health = 100

var flash_timer:Timer
var stun_timer:Timer
var flashed = false
var stunned = false

var velocity = Vector2(0, 0)
var acceleration = Vector2()
var wave_name = ""
var despawned = false

var halo_scene = preload("res://Items/Halo/Halo.tscn")
export(Resource) var explosion_scene = preload("res://Enemies/Explosion/Explosion.tscn")
export(Resource) var hurt_sound = preload("res://Enemies/EnemyHurt.wav")
export(Resource) var die_sound = preload("res://Enemies/EnemyDeath.wav")

signal died
signal hurt(health, max_health)

func _physics_process(delta):
  velocity.y += acceleration.y * delta
  velocity.x += acceleration.x * delta

  velocity.x = min(velocity.x, max_speed.x)
  velocity.x = max(velocity.x, -max_speed.x)
  velocity.y = min(velocity.y, max_speed.y)
  velocity.y = max(velocity.y, -max_speed.y)

  if stunned:
    velocity.x = 0
    velocity.y = 0

  position += velocity * delta

func _ready():
  alive = true
  health = max_health

  flash_timer = Timer.new()
  flash_timer.one_shot = true
  flash_timer.connect("timeout", self, "_on_Flash_timer_timeout")
  flash_timer.set_name("FlashTimer")
  add_child(flash_timer)

  stun_timer = Timer.new()
  stun_timer.one_shot = true
  stun_timer.connect("timeout", self, "_on_Stun_timer_timeout")
  stun_timer.set_name("StunTimer")
  add_child(stun_timer)

  EventBus.connect("chapter_complete", self, "_on_chapter_complete")

  wave_name = Game.scene.wave_manager.current_wave

func _on_chapter_complete():
  if !alive:
    return

  despawned = true
  die()

func hurt(damage):
  if !alive:
    return

  flash()
  stun()

  health -= damage
  if health <= 0:
    die()

  Game.scene.sound.play(hurt_sound)

  emit_signal("hurt", health, max_health)

func die():
  alive = false

  if !despawned:
    Game.scene.score(points)
    explode()
    Game.scene.sound.play(die_sound)

  emit_signal("died")

  spawn_halos()
  queue_free()

func spawn_halos():
  for _i in range(0, halos):
    var halo = halo_scene.instance()
    var rotation = randf() * TAU
    Game.scene.items.call_deferred("add_child", halo)
    halo.global_position = global_position
    halo.velocity = Vector2(
        cos(rotation),
        sin(rotation)
    ) * (250 + randf() * halo_force)

func explode():
  var explosion = explosion_scene.instance()
  explosion.global_position = global_position
  explosion.rotation = rotation
  Game.scene.explosions.add_child(explosion)

func flash():
  modulate = Color(0, 0, 0, 1)
  flashed = false
  flash_timer.start(flash_time)

func stun():
  stunned = true
  stun_timer.start(stun_time)

func _on_Stun_timer_timeout():
  stunned = false

func _on_Flash_timer_timeout():
  if flashed:
    modulate = Color(1, 1, 1, 1)
  else:
    modulate = Color(8, 8, 8, 1)
    flashed = true
    flash_timer.start(flash_time)

func _on_body_entered(body):
  if body.has_method("hurt"):
    body.hurt(1)
