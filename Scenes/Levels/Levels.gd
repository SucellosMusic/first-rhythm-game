extends Node2D

#sequencer
@onready var sequencer = $Sequencer

#audio sequences
@onready var audioPlayer : AudioStreamPlayer = $AudioStreamPlayer

#shapes
@onready var shapes = $"Assigned Shapes".get_children()
@onready var hints = $Hints.get_children()
@onready var altHints = $"Alt Hints".get_children()
@onready var receivers = $Receivers.get_children()
@onready var altReceivers = $"Alt Receivers".get_children()

#collision detectors
var shapePerf : Array[Area2D] = []
var shapeGreat : Array[Area2D] = []
var shapeOkay : Array[Area2D] = []
var altRecCollision : Array[Area2D] = []

#time
@onready var syncToStart : float = AudioServer.get_time_to_next_mix()
@export var bpm : float;
@onready var beatTimer : Timer = $Beats
@export var beatOffset : float;
@onready var beat : float = (60/bpm)
var beatOne : bool = true;

#scoring
@onready var scoreDisplay : Label = $"Score Text"
var posPoint : int = 0
var orientPoint : int = 0
var timePoint : int = 0
var totalScore : int = 0
var takeScore : bool = false

#vector locations
@onready var shapeSTORAGE = Vector2(-500, 400)
@onready var receiverSTORAGE = Vector2(-500, 150)
@onready var altReceiverStorage = Vector2(-500, 650)
@onready var hintsStorage = Vector2(-500, 900)
@onready var altRecPos = Vector2(640, 320)
var prevRec;
var prevHint;
var prevShape;
var prevAltRec;
var prevAltHint;

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	for s in shapes:
		s.position = shapeSTORAGE
		shapePerf.append(s.get_child(1))
		shapeGreat.append(s.get_child(2))
		shapeOkay.append(s.get_child(3))

	for r in receivers:
		r.position = receiverSTORAGE
	
	for ar in altReceivers:
		ar.position = altReceiverStorage
		altRecCollision.append(ar.get_child(1))
	
	for h in hints:
		h.position = hintsStorage
		
	for ah in altHints:
		ah.position = hintsStorage
	
	sequencer.initialize_sequencer()
	sequencer.set_initial_positions()
	
	#audioPlayer.play()
	beatTimer.start(syncToStart + beatOffset)
	
func _on_beats_timeout() -> void:
	beatTimer.start(beat * sequencer.nextBeat)
	takeScore = true
	if beatOne:
		sequencer.set_next_position()
		beatOne = false
	else:
		sequencer.increment_values()
		sequencer.set_next_position()
	
	if prevShape != null:
		prevShape.position = shapeSTORAGE
	if prevRec != null:
		prevRec.position = receiverSTORAGE
	if prevHint != null:
		prevHint.position = hintsStorage
	if prevAltRec != null:
		prevAltRec.position = altReceiverStorage
	if prevAltHint != null:
		prevAltHint.position = hintsStorage

	if sequencer.currSequenceValues == sequencer.get_current_sequence_size() - 2:
		receivers[sequencer.recShape].position = sequencer.recPos
		receivers[sequencer.recShape].rotation_degrees = sequencer.recOrient
		hints[sequencer.hintShape].position = sequencer.hintPos
		hints[sequencer.hintShape].rotation_degrees = sequencer.hintOrient
		altHints[sequencer.hintShape].position = altRecPos
		altHints[sequencer.hintShape].rotation_degrees = sequencer.hintOrient - 45
		prevRec = receivers[sequencer.recShape]
		prevHint = hints[sequencer.hintShape]
		prevAltHint = altHints[sequencer.hintShape]
		prevShape = shapes[sequencer.recShape]
	elif sequencer.currSequenceValues == sequencer.get_current_sequence_size() - 1:
		receivers[sequencer.recShape].position = sequencer.recPos
		receivers[sequencer.recShape].rotation_degrees = sequencer.recOrient
		altReceivers[sequencer.recShape].position = altRecPos
		altReceivers[sequencer.recShape].rotation_degrees = sequencer.recOrient - 45
		hints[sequencer.hintOptionAShape].position = sequencer.get_option_A_hint_position()
		hints[sequencer.hintOptionAShape].rotation_degrees = sequencer.hintOptionAOrient
		altHints[sequencer.hintOptionBShape].position = sequencer.get_option_B_hint_position()
		altHints[sequencer.hintOptionBShape].rotation_degrees = sequencer.hintOptionBOrient
		prevRec = receivers[sequencer.recShape]
		prevAltRec = altReceivers[sequencer.recShape]
		prevHint = hints[sequencer.hintOptionAShape]
		prevAltHint = altHints[sequencer.hintOptionBShape]
		prevShape = shapes[sequencer.recShape]
	else:
		receivers[sequencer.recShape].position = sequencer.recPos
		receivers[sequencer.recShape].rotation_degrees = sequencer.recOrient
		hints[sequencer.hintShape].position = sequencer.hintPos
		hints[sequencer.hintShape].rotation_degrees = sequencer.hintOrient
		prevRec = receivers[sequencer.recShape]
		prevHint = hints[sequencer.hintShape]
		prevShape = shapes[sequencer.recShape]
		
	
func _process(_delta: float) -> void:
	shapes[sequencer.recShape].position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("Input Shape"):
		get_total_score()
		scoreDisplay.text = str(totalScore)
	
	if sequencer.currSequenceValues == sequencer.get_current_sequence_size() - 1:
		sequencer.set_next_sequence(altRecCollision[sequencer.recShape])
	
func get_total_score() -> void:
	if takeScore == true:
		posPoint = get_position_score()
		orientPoint = get_orient_score()
		timePoint = get_time_score()
		totalScore += posPoint + orientPoint + timePoint
		takeScore = false

func get_position_score() -> int:
	if shapePerf[sequencer.recShape].has_overlapping_areas():
		return 3
	elif shapeGreat[sequencer.recShape].has_overlapping_areas():
		return 2
	elif shapeOkay[sequencer.recShape].has_overlapping_areas():
		return 1
	return 0

func get_orient_score() -> int:
	if shapeOkay[sequencer.recShape].has_overlapping_areas():
		if shapes[sequencer.recShape].rotation == receivers[sequencer.recShape].rotation:
			return 1
	return 0

func get_time_score() -> int:
	if shapeOkay[sequencer.recShape].has_overlapping_areas():
		if beatTimer.time_left > .01 && beatTimer.time_left < .3:
			return 3
		elif beatTimer.time_left > .3 && beatTimer.time_left < .6:
			return 2
		elif beatTimer.time_left > .6 && beatTimer.time_left < 1:
			return 1
	return 0
