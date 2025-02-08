extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_float) -> void:
	
	var currRot = self.get_rotation_degrees()
	
	if (Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_mouse_left_click")):
		self.set_rotation_degrees(currRot-45)


	if (Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_mouse_right_click")):
		self.set_rotation_degrees(currRot+45)
