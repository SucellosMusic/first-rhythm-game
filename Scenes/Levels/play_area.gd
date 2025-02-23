extends Node2D

#UI
@onready var startButton : Button = $Start
@onready var instructions : Label = $Instructions

#Audio
@onready var audioPlayer : AudioStreamPlayer = $AudioStreamPlayer

#shapes and receivers
@onready var shapes = $PlayerShapes.get_children()
@onready var receivers = $Receivers.get_children()
@onready var altReceivers = $"Alt Receivers".get_children()
@onready var hints = $Hints.get_children()

#path
@onready var pathFollow : PathFollow2D = $"Path2D/PathFollow2D"
@onready var pathFollowTwo : PathFollow2D = $Path2D/PathFollow2D2
@onready var receiverPos : Node2D = $"Path2D/PathFollow2D/Receiver Positioner"
@onready var hintPos : Node2D = $"Path2D/PathFollow2D2/Hint Positioner"

#Sequences
@export_range(0, 6) var receiverPattern : Array[int];
@export_range(-135, 180, 45) var receiverOrientation : Array[int]
var hintSelection : int = 1
var selection : int = 0
var currSelection : int;
var prevSelection : int;
var currRotation : int = 0
var hintPrevSelection : int;
var hintCurrSelection : int;
var hintRotation : int;

#collision detectors
var shapePerf : Array[Area2D] = []
var shapeGreat : Array[Area2D] = []
var shapeOkay : Array[Area2D] = []

#time
@onready var syncToStart : float = AudioServer.get_time_to_next_mix()
@export var bpm : float;
@onready var beats : float = (1/bpm)*60
@onready var beatTimer : Timer = $Beats
@export var beatOffset : float;

#misc var
@onready var shapeSTORAGE = Vector2(-500, 400)
@onready var receiverSTORAGE = Vector2(-500, 150)
@onready var altReceiverStorage = Vector2(-500, 650)
@onready var hintsStorage = Vector2(-500, 900)
var startSequence : bool = false
var recAnimate : Array[AnimatedSprite2D] = []
var altRecAnimate : Array[AnimatedSprite2D] = []

#scoring
@onready var scoreDisplay : Label = $"Score Int"
var posPoint : int = 0
var orientPoint : int = 0
var timePoint : int = 0
var totalScore : int = 0
var takeScore : bool = false


func _ready() ->void:
	for s in shapes:
		s.position = shapeSTORAGE
		shapePerf.append(s.get_child(1))
		shapeGreat.append(s.get_child(2))
		shapeOkay.append(s.get_child(3))
		
	for r in receivers:
		r.position = receiverSTORAGE
		recAnimate.append((r.get_child(0)))
		
	for ar in altReceivers:
		ar.position = altReceiverStorage
		altRecAnimate.append((ar.get_child(0)))
		
	for ra in recAnimate:
		ra.play()
		
	for ara in altRecAnimate:
		ara.play()

	pathFollowTwo.progress = 200
	
func _on_start_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	audioPlayer.play()
	beatTimer.start(syncToStart + beatOffset)
	next_shape()
	startSequence = true
	startButton.hide()
	instructions.hide()
	

func get_score() -> void:
	if takeScore == true:
		posPoint = get_pos_score()
		orientPoint = get_orient_score()
		timePoint = get_time_score()
		totalScore += posPoint + orientPoint + timePoint
		takeScore = false

func get_pos_score() -> int:
	if shapePerf[currSelection].has_overlapping_areas():
		return 3
	elif shapeGreat[currSelection].has_overlapping_areas():
		return 2
	elif shapeOkay[currSelection].has_overlapping_areas():
		return 1
	return 0

func get_orient_score() -> int:
	if shapeOkay[currSelection].has_overlapping_areas():
		if shapes[currSelection].rotation == receivers[currSelection].rotation:
			return 1
	return 0

func get_time_score() -> int:
	if shapeOkay[currSelection].has_overlapping_areas():
		if beatTimer.time_left > 0 && beatTimer.time_left < .2:
			return 3
		elif beatTimer.time_left > .3 && beatTimer.time_left < .5:
			return 2
		elif beatTimer.time_left > 6 && beatTimer.time_left < 1:
			return 1
	return 0

func next_shape() -> void:
	hintPrevSelection = hintCurrSelection
	prevSelection = currSelection
	if selection == 6:
		selection = 0
	else:
		selection += 1
		
	if hintSelection == 6:
		hintSelection = 0
	else:
		hintSelection += 1
	
	
	currSelection = receiverPattern[selection]
	currRotation = receiverOrientation[selection]
	hintCurrSelection = receiverPattern[hintSelection]
	hintRotation = receiverOrientation[hintSelection]
	
	

func _on_in_timer_timeout() -> void:
	beatTimer.start(beats)
	next_shape()
	startSequence = true
	takeScore = true
	pathFollow.progress += 200
	pathFollowTwo.progress += 200

func _process(delta: float) -> void:
	hints[hintPrevSelection].position = hintsStorage
	receivers[prevSelection].position = receiverSTORAGE
	shapes[prevSelection].position = shapeSTORAGE
	
	hints[hintCurrSelection].position = hintPos.global_position
	hints[hintCurrSelection].rotation_degrees = hintRotation
	
	if startSequence == true:
		receivers[currSelection].position = receiverPos.global_position
		receivers[currSelection].rotation_degrees = currRotation
		shapes[currSelection].position = get_local_mouse_position()
	
	if Input.is_action_just_pressed("letter_A"):
		get_score()
		scoreDisplay.text = str(totalScore)
		
	if startSequence == true && !audioPlayer.playing:
		startSequence = false
		await get_tree().create_timer(3).timeout
		get_tree().quit()
