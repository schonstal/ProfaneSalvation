extends Control

var pause_menu = preload("res://UI/Pause/PauseMenu.tscn")

func _input(event):
  if event.is_action_pressed("pause"):
    var paused = !get_tree().paused
    get_tree().paused = paused
    visible = paused

    var pause_scene = pause_menu.instance()

    if paused:
      add_child(pause_scene)
    else:
      pause_scene.queue_free()
