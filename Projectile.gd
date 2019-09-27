extends Area2D

export var velocity = Vector2(0, -1000)
export var acceleration = Vector2(0, 0)

export var damage = 1
export var rotate_explosion = false

export(Resource) var explosion_scene = preload("res://Projectiles/BlueFireball/EnemyFireballExplosion/EnemyFireballExplosion.tscn")
var halo_scene = preload("res://Items/Halo/Halo.tscn")
var deflect_sound = preload("res://Player/SFX/DeflectSound.tscn")

signal died(explosion)

func _ready():
  connect("body_entered", self, "_on_body_enter")
  connect("area_entered", self, "_on_body_enter")
  EventBus.connect("chapter_complete", self, "_on_chapter_complete")
  EventBus.connect("clear_projectiles", self, "_on_clear_projectiles")

  if velocity.length_squared() > 0:
    rotation = velocity.angle()

func _physics_process(delta):
  velocity += acceleration * delta
  position += velocity * delta

  if global_position.y < -400:
    die()

  if global_position.y > 1200:
    die()

  if global_position.x < -100:
    die()

  if global_position.x > 2020:
    die()

func _process(_delta):
  if velocity.length_squared() > 0:
    rotation = velocity.angle()

func _on_body_enter(body):
  if body.has_method("hurt"):
    body.hurt(damage)
    die()

func deflect():
  Game.scene.sound.play_scene(deflect_sound, "deflect")
  die()

func die():
  var explosion = explosion_scene.instance()
  explosion.global_position = global_position
  if rotate_explosion:
    explosion.rotation = rotation - PI / 2
  Game.scene.explosions.call_deferred("add_child", explosion)
  emit_signal("died", explosion)
  queue_free()

func _on_clear_projectiles():
  die()

func _on_chapter_complete():
  var halo = halo_scene.instance()
  var rotation = randf() * TAU
  Game.scene.items.call_deferred("add_child", halo)
  halo.global_position = global_position
  halo.velocity = Vector2(
      cos(rotation),
      sin(rotation)
  ) * (250 + randf() * 250)

  die()
