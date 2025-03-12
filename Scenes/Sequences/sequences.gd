extends Node

#positions
@onready var recPosSetter : PathFollow2D = $"Path2D/Receiver Position Setter"
@onready var recPosition : Node2D = $"Path2D/Receiver Position Setter/Receiver Position"
@onready var hintPosSetter : PathFollow2D = $"Path2D/Hint Position Setter"
@onready var hintPosition : Node2D = $"Path2D/Hint Position Setter/Hint Position"

#exports
@export_range(0, 6) var receiverPattern : Array[int];
@export_range(0, 6) var hintPattern : Array[int];
@export_range(-135, 180, 45) var receiverOrientation : Array[int];
@export_range(-135, 180, 45) var hintOrientation : Array[int];
@export_enum("Eighth:.5", "Quarter:1", "Half:2", "Whole:4") var nextBeat : Array[int];
@export var incrementValue : int;
@export var hintStart : int;
@export var posStart : int;
