extends Node

#sequences
@onready var sequences = self.get_children();
var currSequence : int = 0;

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
	pass

func set_shape_values() -> void:
	pass

func set_initial_position() -> void:
	pass

func set_next_position() -> void:
	pass
