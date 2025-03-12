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

#scoring
@onready var scoreDisplay : Label = $"Score Text"
var posPoint : int = 0
var orientPoint : int = 0
var timePoint : int = 0
var totalScore : int = 0
var takeScore : bool = false

#misc var
@onready var shapeSTORAGE = Vector2(-500, 400)
@onready var receiverSTORAGE = Vector2(-500, 150)
@onready var altReceiverStorage = Vector2(-500, 650)
@onready var hintsStorage = Vector2(-500, 900)


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
	
	sequencer.set_initial_positions()
	sequencer.zero_values()
	sequencer.set_initial_sequence()


func _process(delta: float) -> void:
	pass

func get_total_score() -> void:
	if takeScore == true:
		posPoint = get_position_score()
		orientPoint = get_orient_score()
		timePoint = get_time_score()
		totalScore += posPoint + orientPoint + timePoint
		takeScore = false

func get_position_score() -> int:
	if shapePerf[0].has_overlapping_areas():
		return 3
	elif shapeGreat[0].has_overlapping_areas():
		return 2
	elif shapeOkay[0].has_overlapping_areas():
		return 1
	return 0

func get_orient_score() -> int:
	if shapeOkay[0].has_overlapping_areas():
		if shapes[0].rotation == receivers[0].rotation:
			return 1
	return 0

func get_time_score() -> int:
	if shapeOkay[0].has_overlapping_areas():
		if beatTimer.time_left > .01 && beatTimer.time_left < .3:
			return 3
		elif beatTimer.time_left > .3 && beatTimer.time_left < .6:
			return 2
		elif beatTimer.time_left > .6 && beatTimer.time_left < 1:
			return 1
	return 0
