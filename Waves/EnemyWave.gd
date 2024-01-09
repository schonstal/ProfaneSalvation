extends Node2D

var dead_enemies = 0
var completed = false

@export var complete_time = 2.0
@export var final = false
var time = 0.0

@export var enemy_count = 0

var health_scene = preload("res://Items/Health/HealthPickup.tscn")

func _ready():
  if enemy_count == 0:
    enemy_count = get_child_count()

  EventBus.connect("enemy_died", Callable(self, "_on_enemy_died"))

func _process(delta):
  time += delta
  if time > complete_time:
    complete()

func _on_enemy_died(wave, _name):
  if wave != self.name:
    return

  dead_enemies += 1
  if dead_enemies >= enemy_count:
    complete()

func complete():
  if completed:
    return

  completed = true

  if final:
    EventBus.emit_signal("chapter_complete")
    spawn_health()
  else:
    EventBus.emit_signal("wave_completed", name)

func spawn_health():
  var health = health_scene.instantiate()
  Game.scene.items.call_deferred("add_child", health)
  health.global_position = Vector2(1920 / 2, 100)
