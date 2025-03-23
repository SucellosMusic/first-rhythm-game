extends Node

#positions
@onready var recPosSetter : PathFollow2D = $"Path2D/Receiver Position Setter"
@onready var hintPosSetter : PathFollow2D = $"Path2D/Hint Position Setter"

#exports
@export_range(0, 6) var receiverPattern : Array[int];
#@export_range(0, 6) var hintPattern : Array[int];
@export_range(-135, 180, 45) var receiverOrientation : Array[int];
#@export_range(-135, 180, 45) var hintOrientation : Array[int];
@export_range(.5, 4, .5) var nextBeat : Array[float];
@export var incrementValue : int;
@export var hintStart : int;
@export var posStart : int;
