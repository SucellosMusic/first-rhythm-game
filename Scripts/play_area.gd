extends Node2D

#shapes and receivers
@onready var shapes = $PlayerShapes.get_children()
@onready var receivers = $Receivers.get_children()

#path
@onready var pathFollow : PathFollow2D = $"Path2D/PathFollow2D"
@onready var receiverPos : Node2D = $"Path2D/PathFollow2D/Receiver Positioner"

#collision detectors
var shapePerf : Array[Area2D] = []
var shapeGreat : Array[Area2D] = []
var shapeOkay : Array[Area2D] = []

#time
@onready var syncToStart = AudioServer.get_time_to_next_mix()
@export var bpm : int;
@onready var beats : int = (60/bpm)
@onready var beatTimer : Timer = $Beats
var beat : int = 0
var bar : int = 1

#misc var
@onready var shapeSTORAGE = $"Shapes Storage".global_position
@onready var receiverSTORAGE = $"Receiver Storage".global_position
var selection : int = 0
var prevSelection : int = 0

#scoring
@onready var scoreDisplay : Label = $"Score Int"
var posPoint : int = 0
var orientPoint : int = 0
var timePoint : int = 0
var totalScore : int = 0
var takeScore : bool = false


func _ready() ->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	for s in shapes:
		s.position = shapeSTORAGE
		shapePerf.append(s.get_child(1))
		shapeGreat.append(s.get_child(2))
		shapeOkay.append(s.get_child(3))
		
	for r in receivers:
		r.position = receiverSTORAGE
	
	beatTimer.start(syncToStart + .1)


func get_score() -> void:
	if takeScore == true:
		posPoint = get_pos_score()
		orientPoint = get_orient_score()
		timePoint = get_time_score()
		totalScore += posPoint + orientPoint + timePoint
		takeScore = false


func get_pos_score() -> int:
	if shapePerf[selection].has_overlapping_areas():
		return 3
	elif shapeGreat[selection].has_overlapping_areas():
		return 2
	elif shapeOkay[selection].has_overlapping_areas():
		return 1
	return 0


func get_orient_score() -> int:
	if shapeOkay[selection].has_overlapping_areas():
		if shapes[selection].rotation == receivers[selection].rotation:
			return 1
	return 0
	


func get_time_score() -> int:
	if shapeOkay[selection].has_overlapping_areas():
		if beatTimer.time_left > 0 && beatTimer.time_left < .02:
			return 3
		elif beatTimer.time_left > .02 && beatTimer.time_left < .05:
			return 2
		elif beatTimer.time_left > .05 && beatTimer.time_left < .1:
			return 1
	return 0


func next_shape() -> void:
	prevSelection = selection
	if selection == 6:
		selection = 0
	else:
		selection += 1


func _on_in_timer_timeout() -> void:
	beatTimer.start(beats)
	
	if beat == 2 || beat == 4:
		takeScore = true
		pathFollow.progress += 50
		next_shape()
	
	if beat == 4:
		bar += 1
		beat = 1
	else: 
		beat += 1
	


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_A:
			get_score()
			scoreDisplay.text = str(totalScore)


func _process(_float) -> void:
	match beat:
		1:
			receivers[prevSelection].position = receiverSTORAGE
			shapes[prevSelection].position = shapeSTORAGE
			receivers[selection].position = receiverPos.global_position
			shapes[selection].position = get_local_mouse_position()
		2:
			shapes[prevSelection].position = shapeSTORAGE
			receivers[prevSelection].position = receiverSTORAGE
			receivers[selection].position = receiverPos.global_position
			shapes[selection].position = get_local_mouse_position()
		3:
			shapes[prevSelection].position = shapeSTORAGE
			receivers[prevSelection].position = receiverSTORAGE
			receivers[selection].position = receiverPos.global_position
			shapes[selection].position = get_local_mouse_position()
		4:
			shapes[prevSelection].position = shapeSTORAGE
			receivers[prevSelection].position = receiverSTORAGE
			receivers[selection].position = receiverPos.global_position
			shapes[selection].position = get_local_mouse_position()
