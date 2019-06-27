extends Sprite

export var angular_velocity = 1.0
export var fade_duration = 5

onready var fade_tween = $FadeTween

var velocity = Vector2(0, 0)

func _ready():
  angular_velocity *= randf()
  fade_duration *= randf()

  frame = randi() % 4

  var angle = randf() * TAU
  velocity = Vector2(cos(angle), sin(angle)) * (randf() * 200 + 50)

  fade_tween.connect("tween_completed", self, "_on_FadeTween_tween_completed")

  fade_tween.interpolate_property(
      self,
      "modulate",
      Color(1, 1, 1, 1),
      Color(1, 1, 1, 0),
      fade_duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  fade_tween.start()

func _on_FadeTween_tween_completed(object, key):
  queue_free()

func _physics_process(delta):
  position += velocity * delta

func _process(delta):
  rotation += TAU * delta * angular_velocity
