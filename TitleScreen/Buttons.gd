extends VBoxContainer

onready var new_game = $NewGameButton
onready var quit = $QuitButton

func _ready():
  new_game.initialize_focus()

  new_game.connect("pressed", self, "_on_NewGameButton_pressed")
  quit.connect("pressed", self, "_on_QuitButton_pressed")

  MusicPlayer.play_file("res://Music/menu.ogg")

func _on_NewGameButton_pressed():
  Game.chapter = 0
  Game.change_scene("res://Scenes/Gameplay.tscn")

func _on_QuitButton_pressed():
  get_tree().quit()
