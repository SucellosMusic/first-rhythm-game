extends CheckButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.button_pressed == true:
		self.text = "Enabled"
	else:
		self.text = "Disabled"

func _on_toggled(_toggled_on: bool) -> void:
	if self.button_pressed == true:
		self.text = "Enabled"
	else:
		self.text = "Disabled"
