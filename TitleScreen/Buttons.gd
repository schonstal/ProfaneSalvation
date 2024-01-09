extends VBoxContainer

@onready var new_game = $NewGame/Button
@onready var quit = $Quit/Button

func _ready():
  new_game.pressed.connect(_on_NewGameButton_pressed)
  quit.pressed.connect(_on_QuitButton_pressed)

  new_game.grab_focus()

  MusicPlayer.play_file("res://Music/menu.ogg")

func _on_NewGameButton_pressed():
  Game.wave = 0
  Game.gun_level = 0
  MusicPlayer.stop()
  Game.change_scene_to_file("res://Scenes/Gameplay.tscn")

func _on_QuitButton_pressed():
  get_tree().quit()
