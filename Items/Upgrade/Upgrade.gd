extends Area2D

const UP = Vector2(0, -1)

onready var sprite = $Sprite
onready var animation = $Sprite/AnimationPlayer

export var speed = 600
export var angular_velocity = 0.5
export var target_velocity = Vector2(0, 100)
export var points = 25
export var wait_time = 1.0

var velocity = Vector2(-300, -500)
var wait_timer = 0

signal died

export(Resource) var collect_sound = preload("res://Items/Upgrade/CollectSound.tscn")

func _ready():
  connect("body_entered", self, "_on_body_entered")
  rotation = randf() * PI * 2

func _process(delta):
  wait_timer += delta
  rotation += PI * 2 * delta * angular_velocity
  if global_position.y > 1200:
    queue_free()

func _physics_process(delta):
  if wait_timer > wait_time:
    var direction = (Game.scene.player.position - global_position).normalized()
    velocity = direction * 800

  position += velocity * delta

func _on_body_entered(_body):
  die()

func die():
  Game.scene.increment_score(points)
  Game.scene.sound.play_scene(collect_sound, "upgrade")
  EventBus.emit_signal("upgrade_collected")
  queue_free()
