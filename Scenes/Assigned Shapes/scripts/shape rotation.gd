extends Node2D

var currRotation : float;



func _process(_float) -> void:
	currRotation = self.rotation_degrees
	if Input.is_action_just_pressed("Rotate Left"):
		self.rotation_degrees = currRotation - 45
		
	if Input.is_action_just_pressed("Rotate Right"):
		self.rotation_degrees = currRotation + 45
