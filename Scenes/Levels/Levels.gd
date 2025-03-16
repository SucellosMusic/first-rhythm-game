extends Node2D

#sequencer
@onready var sequencer = $Sequencer

#audio sequences
@onready var audioPlayer : AudioStreamPlayer = $AudioStreamPlayer

#shapes
@onready var shapes = $"Assigned Shapes".get_children()
@onready var hints = $Hints.get_children()
@onready var receivers = $Receivers.get_children()
@onready var altReceivers = $"Alt Receivers".get_children()

#collision detectors
var shapePerf : Array[Area2D] = []
var shapeGreat : Array[Area2D] = []
var shapeOkay : Array[Area2D] = []

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

#storage
@onready var shapeSTORAGE = Vector2(-500, 400)
@onready var receiverSTORAGE = Vector2(-500, 150)
@onready var altReceiverStorage = Vector2(-500, 650)
@onready var hintsStorage = Vector2(-500, 900)
var prevRec;
var prevHint;
var prevShape;


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
		
	for h in hints:
		h.position = hintsStorage
		
	
	sequencer.set_initial_sequence()
	sequencer.set_initial_positions()
	sequencer.set_initial_values()
	
	audioPlayer.play()
	beatTimer.start(syncToStart + beatOffset)
	

func _on_beats_timeout() -> void:
	beatTimer.start(beat * sequencer.nextBeat)
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
	
	receivers[sequencer.recShape].position = sequencer.recPos
	hints[sequencer.hintShape].position = sequencer.hintPos
	receivers[sequencer.recShape].rotation_degrees = sequencer.recOrient
	hints[sequencer.hintShape].rotation_degrees = sequencer.hintOrient
	prevRec = receivers[sequencer.recShape]
	prevHint = hints[sequencer.hintShape]
	prevShape = shapes[sequencer.recShape]
	


func _process(delta: float) -> void:
	shapes[sequencer.recShape].position = get_global_mouse_position()
	

func get_total_score() -> void:
	if takeScore == true:
		posPoint = get_position_score()
		orientPoint = get_orient_score()
		timePoint = get_time_score()
		totalScore += posPoint + orientPoint + timePoint
		takeScore = false

func get_position_score() -> int:
	if shapePerf[shapes[sequencer.recShape]].has_overlapping_areas():
		return 3
	elif shapeGreat[shapes[sequencer.recShape]].has_overlapping_areas():
		return 2
	elif shapeOkay[shapes[sequencer.recShape]].has_overlapping_areas():
		return 1
	return 0

func get_orient_score() -> int:
	if shapeOkay[shapes[sequencer.recShape]].has_overlapping_areas():
		if shapes[shapes[sequencer.recShape]].rotation == receivers[shapes[sequencer.recShape]].rotation:
			return 1
	return 0

func get_time_score() -> int:
	if shapeOkay[shapes[sequencer.recShape]].has_overlapping_areas():
		if beatTimer.time_left > .01 && beatTimer.time_left < .3:
			return 3
		elif beatTimer.time_left > .3 && beatTimer.time_left < .6:
			return 2
		elif beatTimer.time_left > .6 && beatTimer.time_left < 1:
			return 1
	return 0
