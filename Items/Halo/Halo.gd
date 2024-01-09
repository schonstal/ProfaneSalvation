extends Area2D

const UP = Vector2(0, -1)

@onready var sprite = $Sprite2D
@onready var animation = $Sprite2D/AnimationPlayer

@export var speed = 600
@export var angular_velocity = 0.5
@export var target_velocity = Vector2(0, 100)
@export var points = 25
@export var wait_time = 0.1

var velocity = Vector2(-300, -500)
var wait_timer = 0

signal died

@export var collect_sound: Resource = preload("res://Items/Halo/CollectSound.tscn")

func _ready():
  connect("body_entered", Callable(self, "_on_body_entered"))
  rotation = randf() * PI * 2
  animation.play("Spin")
  animation.advance(randf() * 0.4)

func _process(delta):
  wait_timer += delta
  rotation += PI * 2 * delta * angular_velocity
  if global_position.y > 1200:
    queue_free()

func _physics_process(delta):
  if Game.scene.player.attacking || Game.scene.player.dead || wait_timer < wait_time:
    velocity.x += (target_velocity.x - velocity.x) * 0.1
    velocity.y += (target_velocity.y - velocity.y) * 0.1
  else:
    var direction = (Game.scene.player.position - global_position).normalized()
    velocity = direction * 800

  position += velocity * delta

func _on_body_entered(_body):
  die()

func die():
  Game.scene.increment_score(points)
  Game.scene.sound.play_scene(collect_sound, "halo")
  EventBus.emit_signal("halo_collected")
  queue_free()
