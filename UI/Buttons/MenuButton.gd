extends Button

@onready var swords = $Swords
@onready var sword_left = $Swords/Left
@onready var sword_right = $Swords/Right
@onready var label = $Label

@onready var focus_sound = $Focus
@onready var click_sound = $Click
var play_focus_sound = true

func _ready():
  self.connect("focus_entered", _on_focus_entered)
  self.connect("focus_exited", _on_focus_exited)
  self.connect("mouse_entered", _on_mouse_entered)
  self.connect("pressed", _on_pressed)

  var text_width = 200

func _on_focus_entered():
  swords.visible = true

  if play_focus_sound:
    focus_sound.play()

  play_focus_sound = true

func _on_focus_exited():
  swords.visible = false

func _on_mouse_entered():
  grab_focus()

func _on_pressed():
  click_sound.play()

func initialize_focus():
  play_focus_sound = false
  grab_focus()
