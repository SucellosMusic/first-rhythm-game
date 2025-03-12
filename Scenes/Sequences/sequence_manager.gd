extends Node

#sequences
@onready var sequences = self.get_children();
var currSequence : int = 0;
var currSequenceValues : int = 0;

#area2d
@onready var altRec = $"../Alt Receivers".get_children()
var collider : Array[Area2D];

#sequence values
var recShape : int;
var hintShape : int;
var recOrient : int;
var hintOrient : int;
var nextBeat : int;


func _ready() -> void:
	for a in altRec:
		collider.append(a.get_child(1))
		
func set_initial_sequence() -> void:
	currSequence = 0

func zero_values() -> void:
	currSequenceValues = 0

func set_next_sequence(selection : Area2D) -> void:
	for c in collider:
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

func increment_values() -> void:
	currSequenceValues += 1
	recShape = sequences[currSequence].receiverPattern[currSequenceValues]
	hintShape = sequences[currSequence].hintPatter[currSequenceValues]
	recOrient = sequences[currSequence].receiverOrientation[currSequenceValues]
	hintOrient = sequences[currSequence].hintOrientation[currSequenceValues]
	nextBeat = sequences[currSequence].nextBeat[currSequenceValues]

func set_initial_positions() -> void:
	for s in sequences:
		s.recPosSetter.progress = s.posStart
		s.hintPosSetter.progress = s.hintStart

func set_next_position() -> void:
	sequences[currSequence].recPosSetter.progress += sequences[currSequence].incrementValue
