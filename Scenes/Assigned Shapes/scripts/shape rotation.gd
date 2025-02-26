extends Node2D

var currRotation : int;



func _process(_float) -> void:
	currRotation = self.rotation_degrees
	if self.position == get_global_mouse_position():
		if Input.is_action_just_pressed("Rotate Left"):
			self.rotation_degrees = currRotation - 45
			
		if Input.is_action_just_pressed("Rotate Right"):
			self.rotation_degrees = currRotation + 45
	else:
		self.rotation_degrees = 0
