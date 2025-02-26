extends Control

#mouse
@onready var mouseSensSlider : HSlider = $"Mouse Sensitivity/HSlider"
@onready var mouseSenseDisplay : SpinBox = $"Mouse Sensitivity/HSlider/SpinBox"

#rotate left
@onready var rotateLeftOne : Button = $"Rotate Left/Rotate Left One"
@onready var rotateLeftTwo : Button = $"Rotate Left/Rotate Left Two"
@onready var rotateLeftEvents : Array[InputEvent] = InputMap.action_get_events("Rotate Left")

#rotate right
@onready var rotateRightOne : Button = $"Rotate Right/Rotate Right One"
@onready var rotateRightTwo : Button = $"Rotate Right/Rotate Right Two"
@onready var rotateRightEvents : Array[InputEvent] = InputMap.action_get_events("Rotate Right")

#input shape
@onready var inputShapeOne : Button = $"Input Shape/Input Shape One"
@onready var inputShapeTwo : Button = $"Input Shape/Inpute Shape Two"
@onready var inputShapeEvents : Array[InputEvent] = InputMap.action_get_events("Input Shape")

func _ready()-> void:
	rotateLeftOne.text = rotateLeftEvents[0].as_text().trim_suffix(" (Physical)")
	rotateLeftTwo.text = rotateLeftEvents[1].as_text().trim_suffix(" (Physical)")
	rotateRightOne.text = rotateRightEvents[0].as_text().trim_suffix(" (Physical)")
	rotateRightTwo.text = rotateRightEvents[1].as_text().trim_suffix(" (Physical)")
	inputShapeOne.text = inputShapeEvents[0].as_text().trim_suffix(" (Physical)")
	inputShapeTwo.text = inputShapeEvents[1].as_text().trim_suffix(" (Physical)")



func _on_rotate_left_one_pressed() -> void:
	pass
	


func _on_rotate_left_two_pressed() -> void:
	pass # Replace with function body.


func _on_rotate_right_one_pressed() -> void:
	pass # Replace with function body.


func _on_rotate_right_two_pressed() -> void:
	pass # Replace with function body.


func _on_input_shape_one_pressed() -> void:
	pass # Replace with function body.


func _on_inpute_shape_two_pressed() -> void:
	pass # Replace with function body.
