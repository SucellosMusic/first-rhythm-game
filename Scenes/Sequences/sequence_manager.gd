extends Node

#sequences
@onready var sequences = self.get_children();
var currSequence : int = 0;
var currSequenceValues : int = 0;

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
var hintOptionBShape : int;
var hintOptionBOrient : int;

func _ready() -> void:
	pass
	
func get_current_sequence_size() -> int:
	return sequences[currSequence].receiverPattern.size()

func initialize_sequencer() -> void:
	currSequence = 0
	currSequenceValues = 0
	assign_values()

func increment_values() -> void: 
	currSequenceValues += 1
	assign_values()

func assign_values() -> void:
	recShape = sequences[currSequence].receiverPattern[currSequenceValues]
	recOrient = sequences[currSequence].receiverOrientation[currSequenceValues]
	nextBeat = sequences[currSequence].nextBeat[currSequenceValues]
	if currSequenceValues >= sequences[currSequence].receiverPattern.size() - 1:
		hintOptionAShape = sequences[get_option_A_hint()].receiverPattern[0]
		hintOptionAOrient = sequences[get_option_A_hint()].receiverOrientation[0]
		hintOptionBShape = sequences[get_option_B_hint()].receiverPattern[0]
		hintOptionBOrient = sequences[get_option_B_hint()].receiverOrientation[0]
	else:
		hintShape = sequences[currSequence].receiverPattern[currSequenceValues + 1]
		hintOrient = sequences[currSequence].receiverOrientation[currSequenceValues + 1]

func initialize_positions() -> void:
	for s in sequences:
		s.recPosSetter.progress = s.posStart
		s.hintPosSetter.progress = s.hintStart

func set_first_beat_position() -> void:
	recPos = sequences[currSequence].recPosSetter.position
	hintPos = sequences[currSequence].hintPosSetter.position

func set_next_position() -> void:
	sequences[currSequence].recPosSetter.progress += sequences[currSequence].incrementValue
	sequences[currSequence].hintPosSetter.progress += sequences[currSequence].incrementValue
	recPos = sequences[currSequence].recPosSetter.position
	hintPos = sequences[currSequence].hintPosSetter.position
	
func get_option_A_hint_position() -> Vector2:
	return sequences[get_option_A_hint()].recPosSetter.position
	
func get_option_B_hint_position() -> Vector2:
	return sequences[get_option_B_hint()].recPosSetter.position

#func set_next_sequence(next : Area2D) -> void:
	#if next.has_overlapping_areas():
		#if currSequence >= self.get_child_count() - 2:
			#currSequence = 0
		#else:
			#currSequence += 2
		#print("path B Chosen")
	#else:
		#if currSequence == self.get_child_count() - 1:
			#currSequence = 0
		#else:
			#currSequence += 1
		#print("path A Chosen")
	#currSequenceValues = -1

func go_to_option_B() -> void:
	if currSequence >= self.get_child_count() - 2:
		currSequence = 0
	else:
		currSequence += 2
	currSequenceValues = -1
	print("Path B Chosen")
		
func go_to_option_A() -> void:
	if currSequence == self.get_child_count() -1:
		currSequence = 0
	else:
		currSequence += 1
	currSequenceValues = -1
	print("Path A Chosen")

func get_option_A_hint() -> int:
	if currSequence == self.get_child_count() - 1:
		return 0
	else:
		return currSequence + 1

func get_option_B_hint() -> int:
	if currSequence >= self.get_child_count() - 2:
		return 0
	else:
		return currSequence + 2
