tool
extends Area2D

export var length = 500.0
export var shoot_duration = 0.5
export var duration = 0.0

var distance = 0.0
var distance_was = 0.0
var alternate = false

var duration_timer:Timer

onready var chain_links = $ChainLinks
onready var chain_blade = $ChainBlade
onready var link_animation = $ChainLinks/AnimationPlayer
onready var blade_animation = $ChainBlade/AnimationPlayer

onready var collision = $CollisionShape2D
onready var shoot_tween = $ShootTween
onready var daddy = $'..'

export(Resource) var explosion_scene = preload("res://Projectiles/Chain/ChainExplosion.tscn")

func _ready():
  if !Engine.editor_hint:
    link_animation.play("Idle")
    blade_animation.play("Idle")

    distance = 0
    shoot_tween.interpolate_property(
        self,
        "distance",
        0,
        length,
        shoot_duration,
        Tween.TRANS_QUAD,
        Tween.EASE_IN)

    shoot_tween.start()
    shoot_tween.connect("tween_completed", self, "_on_ShootTween_tween_completed")
    connect("body_entered", self, "_on_body_entered")

    if duration > 0:
      duration_timer = Timer.new()
      duration_timer.set_name("WaitTimer")
      duration_timer.wait_time = duration
      duration_timer.one_shot = true
      duration_timer.start()
      add_child(duration_timer)

      duration_timer.connect("timeout", self, "_on_DurationTimer_timeout")

    if daddy != null:
      daddy.connect("died", self, "_on_parent_died")

    EventBus.connect("clear_projectiles", self, "_on_clear_projectiles")
    update_size()

func _process(delta):
  if Engine.editor_hint:
    distance = length
  elif Game.scene != null && Game.scene.player != null:
    if overlaps_body(Game.scene.player):
      Game.scene.player.hurt(1)

  update_size()

func update_size():
  chain_links.region_rect = Rect2(0, 0, 104, distance)
  chain_links.offset.y = -distance / 2
  chain_blade.position.y = chain_links.position.y - distance
  chain_blade.position.x = chain_links.position.x

  if distance_was != distance && alternate:
    collision.shape.extents.y = distance / 2 + 25
    collision.position.y = -distance / 2 - 25

  alternate = !alternate
  distance_was = distance

func _on_ShootTween_tween_completed(object, key):
  pass

func _on_parent_died():
  die()

func _on_DurationTimer_timeout():
  die()

func _on_clear_projectiles():
  # die()
  pass

func _on_body_entered(body):
  if body.has_method("hurt"):
    body.hurt(1)
    die()

func die():
  var explosion = explosion_scene.instance()
  explosion.global_position = global_position
  explosion.global_rotation = global_rotation
  explosion.region_rect = Rect2(0, 0, 198, distance)
  explosion.offset = chain_links.offset
  Game.scene.explosions.add_child(explosion)
  queue_free()
