extends Node

#sequences
@onready var sequences = self.get_children();
var currSequence : int = 0;
var currSequenceValues : int = 0;

#area2d
@onready var altRec = $"../Alt Receivers".get_children()
var collider : Array[Area2D];

#storage
@onready var shapeSTORAGE = Vector2(-500, 400)
@onready var receiverSTORAGE = Vector2(-500, 150)
@onready var altReceiverStorage = Vector2(-500, 650)
@onready var hintsStorage = Vector2(-500, 900)

func _ready() -> void:
	for a in altRec:
		collider.append(a.get_child(1))

func set_current_sequence(selection : Area2D) -> void:
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

func zero_values() -> void:
	currSequenceValues = 0
	
func increment_values() -> void:
	currSequenceValues += 1

func set_initial_positions() -> void:
	for s in sequences:
		s.recPosSetter.progress = s.posStart
		s.hintPosSetter.progress = s.hintStart

func set_next_position() -> void:
	sequences[currSequence].recPosSetter.progress += sequences[currSequence].incrementValue
