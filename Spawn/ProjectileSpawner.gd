extends Node2D

@onready var summon_circle = $SummonCircle

@onready var summon_timer = $SummonTimer
@onready var delay_timer = $DelayTimer

@export var delay = 1.0
@export var summon_time = 1.0

@export var bullet_pattern: Resource = preload("res://BulletPatterns/Lines.tscn")
var halo_scene = preload("res://Items/Halo/Halo.tscn")

var wave_name

func _ready():
  if delay == 0:
    begin()
  else:
    delay_timer.connect("timeout", Callable(self, "_on_DelayTimer_timeout"))
    delay_timer.start(delay)

  summon_circle.connect("fade_finished", Callable(self, "_on_SummonCircle_fade_finished"))

  summon_timer = Timer.new()
  summon_timer.set_name("ShootTimer")
  summon_timer.one_shot = true
  summon_timer.start()
  add_child(summon_timer)

  EventBus.connect("chapter_complete", Callable(self, "_on_chapter_complete"))
  EventBus.connect("wave_completed", Callable(self, "_on_wave_completed"))

  wave_name = Game.scene.wave_manager.current_wave

func begin():
  summon_circle.fade_in()
  summon_timer.start(summon_time)

func _on_DelayTimer_timeout():
  begin()

func _on_SummonCircle_fade_finished():
  queue_free()

func _on_SummonTimer_timeout():
  var pattern = bullet_pattern.instantiate()
  call_deferred("add_child", pattern)

func _on_chapter_complete():
  for i in range(0, 5):
    var halo = halo_scene.instantiate()
    var rotation = randf() * TAU
    Game.scene.items.call_deferred("add_child", halo)
    halo.global_position = global_position
    halo.velocity = Vector2(
        cos(rotation),
        sin(rotation)
    ) * (250 + randf() * 400)

    queue_free()

func _on_wave_completed(name):
  if name == "wave_name":
    summon_circle.fade_out()
