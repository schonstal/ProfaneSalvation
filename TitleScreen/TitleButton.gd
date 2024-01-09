extends HBoxContainer

@onready var sword_left = $SwordLeft
@onready var sword_right = $SwordRight
@onready var button = $Button

@onready var focus_sound = %FocusSound
@onready var click_sound = %ClickSound

@export var play_focus_sound = true

func _ready():
  button.focus_entered.connect(_on_focus_entered)
  button.focus_exited.connect(_on_focus_exited)
  button.mouse_entered.connect(_on_mouse_entered)
  button.pressed.connect(_on_pressed)

func _on_focus_entered():
  sword_left.visible = true
  sword_right.visible = true

  if play_focus_sound:
    focus_sound.play()

  play_focus_sound = true

func _on_focus_exited():
  sword_left.visible = false
  sword_right.visible = false

func _on_mouse_entered():
  button.grab_focus()

func _on_pressed():
  click_sound.play()

func initialize_focus():
  play_focus_sound = false
  button.grab_focus()
