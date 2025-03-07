extends Node

#selector
var currSelection : int;
var prevSelection : int;

#storage
@onready var shapeSTORAGE = Vector2(-500, 400)
@onready var receiverSTORAGE = Vector2(-500, 150)
@onready var altReceiverStorage = Vector2(-500, 650)
@onready var hintsStorage = Vector2(-500, 900)

#positions
@onready var recPosSetter : PathFollow2D = $"Path2D/Receiver Position Setter"
@onready var recPosition : Node2D = $"Path2D/Receiver Position Setter/Receiver Position"
@onready var hintPosSetter : PathFollow2D = $"Path2D/Hint Position Setter"
@onready var hintPosition : Node2D = $"Path2D/Hint Position Setter/Hint Position"
@export var posStart : int;
@export var hintStart : int;
@export var incrementValue : int;

#arrays
@export_range(0, 6) var receiverPattern : Array[int];
@export_range(-135, 180, 45) var receiverOrientation : Array[int];
@export_range(-135, 180, 45) var hintOrientation : Array[int];
@export_enum("Eighth:.5", "Quarter:1", "Half:2", "Whole:4") var nextBeat : Array[int];

#current
var currRecShape : int;
var currRecOrientation : int;
var currHintOrientation : int;
var currNextBeat : int;

func _ready() -> void:
	pass

func set_current() -> void:
	prevSelection = currSelection
	currSelection += 1
	
	currRecShape = receiverPattern[currSelection]
	currRecOrientation = receiverOrientation[currSelection]
	currHintOrientation = hintOrientation[currSelection]
	currNextBeat = nextBeat[currSelection]
	
func set_initial_position() -> void:
	recPosSetter.progress = posStart
	hintPosSetter.progress = hintStart
	
func set_next_position() -> void:
	recPosSetter.progress += incrementValue
	hintPosSetter.progress += incrementValue
