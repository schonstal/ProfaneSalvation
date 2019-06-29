extends Area2D

export var velocity = Vector2(0, -1000)

export var damage = 1

export(Resource) var explosion_scene = preload("res://Enemies/Projectiles/EnemyFireballExplosion/EnemyFireballExplosion.tscn")
var halo_scene = preload("res://Items/Halo/Halo.tscn")
var deflect_sound = preload("res://Player/DeflectSound.tscn")

func _ready():
  connect("body_entered", self, "_on_body_enter")
  connect("area_entered", self, "_on_body_enter")
  EventBus.connect("chapter_complete", self, "_on_chapter_complete")

func _physics_process(delta):
  position += velocity * delta

  if position.y < -100:
    self.queue_free()

  if position.y > 1200:
    self.queue_free()

  if position.x < -100:
    self.queue_free()

  if position.x > 2020:
    self.queue_free()

func _process(delta):
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
  Game.scene.explosions.call_deferred("add_child", explosion)
  queue_free()

func _on_chapter_complete():
  var halo = halo_scene.instance()
  var rotation = randf() * TAU
  Game.scene.items.call_deferred("add_child", halo)
  halo.global_position = global_position
  halo.velocity = Vector2(
      cos(rotation),
      sin(rotation)
  ) * (250 + randf() * 250)

  queue_free()
