extends Node2D

var currRotation : int;



func _process(_float) -> void:
	currRotation = self.rotation_degrees
	if self.position == get_global_mouse_position():
		if Input.is_action_just_pressed("ui_mouse_left_click"):
			self.rotation_degrees = currRotation - 45
			
		if Input.is_action_just_pressed("ui_mouse_right_click"):
			self.rotation_degrees = currRotation + 45
	else:
		self.rotation_degrees = 0
