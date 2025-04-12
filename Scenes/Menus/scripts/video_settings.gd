extends Control

#mode
@onready var windowModeSelect : OptionButton = $"Display Mode/Mode Options"

#vsync
@onready var vsyncToggle : CheckButton = $"Vsync/VSync Setter"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	windowModeSelect.selected = 0
	vsyncToggle.set_pressed(false)


func _on_mode_options_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(0)
		1:
			DisplayServer.window_set_mode(2)
		2:
			DisplayServer.window_set_mode(3)

func _on_v_sync_setter_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		DisplayServer.window_set_vsync_mode(0)
	else:
		DisplayServer.window_set_vsync_mode(1)
	
