extends Node2D

var camera:Node
var player:Node
var explosions:Node
var sound:Node
var particles:Node
var projectiles:Node
var wave_manager:Node
var current_wave:Node
var items:Node
var game_over_layer:Node
var lasers:Node

onready var is_game_over = false

var game_over_scene = preload("res://UI/GameOver/GameOver.tscn")
var game_over_node

var score = 0
var gun_level = 0

func _enter_tree():
  camera = $Camera
  player = $Player
  explosions = $Explosions
  sound = $Sound
  particles = $Particles
  projectiles = $Projectiles
  wave_manager = $WaveManager
  current_wave = $CurrentWave
  items = $Items
  game_over_layer = $GameOverLayer
  lasers = $Lasers

  Game.initialize()

func _ready():
  EventBus.connect("upgrade_collected", self, "_on_upgrade_collected")
  Engine.time_scale = 1
  reset_score()

func _process(delta):
  if Engine.time_scale < 1:
    Engine.time_scale += delta * 3
  if Engine.time_scale > 1:
    Engine.time_scale = 1

  if game_over_node == null && is_game_over && Engine.time_scale >= 1:
    game_over_node = game_over_scene.instance()
    game_over_layer.add_child(game_over_node)

func game_over():
  is_game_over = true
  Engine.time_scale = 0.1
  MusicPlayer.enable_filter()

func increment_score(points):
  score += points

  if score > Game.high_score:
    Game.high_score = score

func reset_score():
  score = 0

func shake(duration = 0.5, frequency = 60, amplitude = 25):
  if camera != null:
    camera.shake(duration, frequency, amplitude)

func _on_upgrade_collected():
  gun_level += 1
  Overlay.fade(Color(0.9, 0.7, 0.2, 0.6), Color(0.9, 0.7, 0.2, 0), 0.3)
