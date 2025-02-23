extends CheckButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.button_pressed == true:
		self.text = "Enabled"
	else:
		self.text = "Disabled"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_toggled(toggled_on: bool) -> void:
	if self.button_pressed == true:
		self.text = "Enabled"
	else:
		self.text = "Disabled"
