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
var nextBeat : float;
var recPos : Vector2;
var hintPos : Vector2;
var hintOptionAShape : int;
var hintOptionAOrient : int;
var hintOptionAPos : Vector2;
var hintOptionBShape : int;
var hintOptionBOrient : int;
var hintOptionBPos : Vector2;


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

func get_current_sequence_size() -> int:
	return sequences[currSequence].hintPattern.size()

func assign_values() -> void:
	recShape = sequences[currSequence].receiverPattern[currSequenceValues]
	recOrient = sequences[currSequence].receiverOrientation[currSequenceValues]
	nextBeat = sequences[currSequence].nextBeat[currSequenceValues]
	if currSequenceValues == sequences[currSequence].hintPattern.size() - 1:
		hintOptionAShape = sequences[get_option_A_hint()].receiverPattern[0]
		hintOptionAOrient = sequences[get_option_A_hint()].receiverOrientation[0]
		hintOptionBShape = sequences[get_option_B_hint()].receiverPattern[0]
		hintOptionBOrient = sequences[get_option_B_hint()].receiverOrientation[0]
	else:
		hintShape = sequences[currSequence].hintPattern[currSequenceValues]
		hintOrient = sequences[currSequence].hintOrientation[currSequenceValues]

func set_initial_positions() -> void:
	for s in sequences:
		s.recPosSetter.progress = s.posStart
		s.hintPosSetter.progress = s.hintStart

func set_next_position() -> void:
	sequences[currSequence].recPosSetter.progress += sequences[currSequence].incrementValue
	sequences[currSequence].hintPosSetter.progress += sequences[currSequence].incrementValue
	recPos = sequences[currSequence].recPosSetter.position
	hintPos = sequences[currSequence].hintPosSetter.position
	
func get_option_A_hint_position() -> void:
	hintOptionAPos = sequences[get_option_A_hint()].posStart
	
func get_option_B_hint_position() -> void:
	hintOptionBPos = sequences[get_option_B_hint()].posStart

func set_next_sequence(next : Area2D) -> void:
	if next.has_overlapping_areas():
		currSequenceValues = 0
		if currSequence >= self.get_child_count() - 2:
			currSequence = 0
		else:
			currSequence += 2
	else:
		currSequenceValues = 0
		if currSequence == self.get_child_count() - 1:
			currSequence = 0
		else:
			currSequence += 1
	
func get_option_A_hint() -> int:
	if currSequence == self.get_child_count() - 1:
		return 0
	else:
		return currSequence + 1

func get_option_B_hint() -> int:
	if currSequence == self.get_child_count() - 2:
		return 0
	else:
		return currSequence + 2
