extends Node

#sequences
@onready var sequenceA  = $SequenceA
@onready var sequenceB  = $SequenceB
@onready var sequenceC  = $SequenceC
@onready var sequenceD  = $SequenceD
@onready var sequenceE  = $SequenceE


#storage
@onready var shapeSTORAGE = Vector2(-500, 400)
@onready var receiverSTORAGE = Vector2(-500, 150)
@onready var altReceiverStorage = Vector2(-500, 650)
@onready var hintsStorage = Vector2(-500, 900)

func set_shape_values() -> void:
	pass

func set_initial_position() -> void:
	pass

func set_next_position() -> void:
	pass
