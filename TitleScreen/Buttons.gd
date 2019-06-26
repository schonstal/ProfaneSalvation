extends VBoxContainer

onready var new_game = $NewGameButton
onready var quit = $QuitButton

func _ready():
  new_game.grab_focus()

  new_game.connect("pressed", self, "_on_NewGameButton_pressed")
  quit.connect("pressed", self, "_on_QuitButton_pressed")

func _on_NewGameButton_pressed():
  get_tree().change_scene("res://Scenes/Gameplay.tscn")

func _on_QuitButton_pressed():
  get_tree().quit()
