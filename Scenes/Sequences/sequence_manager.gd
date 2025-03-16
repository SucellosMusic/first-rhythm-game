extends Node

#sequences
@onready var sequences = self.get_children();
var currSequence : int = 0;
var currSequenceValues : int = 0;

#area2d
@onready var altRec = $"../Alt Receivers".get_children()
var altRecCollider : Array[Area2D];

#sequence values
var recShape : int;
var hintShape : int;
var recOrient : int;
var hintOrient : int;
var nextBeat : int;
var recPos : Vector2;
var hintPos : Vector2;


func _ready() -> void:
	for a in altRec:
		altRecCollider.append(a.get_child(1))
		
func set_initial_sequence() -> void:
	currSequence = 0

func set_initial_values() -> void:
	currSequenceValues = 0
	assign_values()

func increment_values() -> void:
	if currSequenceValues == sequences[currSequence].receiverPattern.size() - 1:
		currSequenceValues = 0
	else: 
		currSequenceValues += 1
	assign_values()

func assign_values() -> void:
	recShape = sequences[currSequence].receiverPattern[currSequenceValues]
	hintShape = sequences[currSequence].hintPattern[currSequenceValues]
	recOrient = sequences[currSequence].receiverOrientation[currSequenceValues]
	hintOrient = sequences[currSequence].hintOrientation[currSequenceValues]
	nextBeat = sequences[currSequence].nextBeat[currSequenceValues]

func set_initial_positions() -> void:
	for s in sequences:
		s.recPosSetter.progress = s.posStart
		s.hintPosSetter.progress = s.hintStart

func set_next_position() -> void:
	sequences[currSequence].recPosSetter.progress += sequences[currSequence].incrementValue
	sequences[currSequence].hintPosSetter.progress += sequences[currSequence].incrementValue
	recPos = sequences[currSequence].recPosSetter.position
	hintPos = sequences[currSequence].hintPosSetter.position

func set_next_sequence() -> void:
	for c in altRecCollider:
		if c.has_overlapping_areas():
			if currSequence >= self.get_child_count() - 2:
				currSequence = 0
			else:
				currSequence += 2
		else:
			if currSequence == self.get_child_count():
				currSequence = 0
			else:
				currSequence += 1
