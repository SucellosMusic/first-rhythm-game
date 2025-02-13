extends Node2D

#Audio
@onready var audioPlayer : AudioStreamPlayer = $AudioStreamPlayer

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
@onready var syncToStart : float = AudioServer.get_time_to_next_mix()
@export var bpm : float;
@onready var beats : float = (1/bpm)*60
@onready var beatTimer : Timer = $Beats
var beatCount : int = 0
var CurrGameTime : float;

#misc var
@onready var shapeSTORAGE = Vector2(-500, 400)
@onready var receiverSTORAGE = Vector2(-500, 150)
var recAnimate : Array[AnimatedSprite2D] = []
@export_range(0, 6) var receiverPattern : Array[int];
@export_range(-90, 180, 45) var receiverOrientation : Array[int]
var selection : int = 0
var currSelection : int = 0
var prevSelection : int = 0
var currRotation : int = 0

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
		recAnimate.append((r.get_child(0)))
	
	for ra in recAnimate:
		ra.play()
	
	audioPlayer.play()
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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_A:
			get_score()
			scoreDisplay.text = str(totalScore)


func next_shape() -> void:
	prevSelection = currSelection
	if selection == 6:
		selection = 0
	else:
		selection += 1
	currSelection = receiverPattern[selection]
	currRotation = receiverOrientation[selection]


func _on_in_timer_timeout() -> void:
	beatTimer.start(beats)
	next_shape()
	takeScore = true
	pathFollow.progress += 50
	
	if beatCount == 4:
		beatCount = 1
	else: 
		beatCount += 1
		
	CurrGameTime += beats
	print("audio time: ", roundi(audioPlayer.get_playback_position()), "game time: ", roundi(CurrGameTime))


func _process(delta: float) -> void:
	match beatCount:
		1:
			receivers[prevSelection].position = receiverSTORAGE
			shapes[prevSelection].position = shapeSTORAGE
			receivers[currSelection].position = receiverPos.global_position
			receivers[currSelection].rotation_degrees = currRotation
			shapes[currSelection].position = get_local_mouse_position()
		2:
			shapes[prevSelection].position = shapeSTORAGE
			receivers[prevSelection].position = receiverSTORAGE
			receivers[currSelection].position = receiverPos.global_position
			receivers[currSelection].rotation_degrees = currRotation
			shapes[currSelection].position = get_local_mouse_position()
		3:
			shapes[prevSelection].position = shapeSTORAGE
			receivers[prevSelection].position = receiverSTORAGE
			receivers[currSelection].position = receiverPos.global_position
			receivers[currSelection].rotation_degrees = currRotation
			shapes[currSelection].position = get_local_mouse_position()
		4:
			shapes[prevSelection].position = shapeSTORAGE
			receivers[prevSelection].position = receiverSTORAGE
			receivers[currSelection].position = receiverPos.global_position
			receivers[currSelection].rotation_degrees = currRotation
			shapes[currSelection].position = get_local_mouse_position()
			
	
