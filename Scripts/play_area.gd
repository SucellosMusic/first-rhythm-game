extends Node2D

#shapes and receivers
@onready var shapes = $PlayerShapes.get_children()
@onready var receivers = $Receivers.get_children()

#path
@onready var pathFollow : PathFollow2D = $"Path2D/PathFollow2D"
@onready var receiverPos : Node2D = $"Path2D/PathFollow2D/Receiver Positioner"

#collision detectors
@onready var shapePerf : Array[Area2D] = []
@onready var shapeGreat : Array[Area2D] = []
@onready var shapeOkay : Array[Area2D] = []

#time
@onready var syncToStart = AudioServer.get_time_to_next_mix()
@export var bpm : int;
@onready var beats : int = (60/bpm)
@onready var beatTimer : Timer = $Beats
var halfBeat : int = 1
var beat : int = 1
var bar : int = 1

#misc var
@onready var shapeSTORAGE = $"Shapes Storage".global_position
@onready var receiverSTORAGE = $"Receiver Storage".global_position
var selection : int = 0
var prevSelection : int = 0

#scoring
@onready var posPoint : int = 0
@onready var orientPoint : int = 0
@onready var timePoint : int = 0


func _ready() ->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	for s in shapes:
		s.position = shapeSTORAGE
		shapePerf.append(s.get_child(1))
		shapeGreat.append(s.get_child(2))
		shapeOkay.append(s.get_child(3))
		
	for r in receivers:
		r.position = receiverSTORAGE
	
	beatTimer.start(syncToStart + .1)

func get_score() ->void:
	posPoint = get_pos_score()
		



func get_pos_score() -> int:
	return 0

func get_orient_score() -> int:
	return 0

func next_shape() -> void:
	prevSelection = selection
	if selection == 6:
		selection = 0
	else:
		selection += 1

func _on_in_timer_timeout() -> void:
	beatTimer.start(beats)
	if halfBeat == 2:
		halfBeat = 1
		beat += 1
		pathFollow.progress += 50
	else:
		halfBeat += 1
	
	if beat == 5:
		beat = 1
		bar += 1


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_A:
			get_score()


func _process(_float) -> void:
	match beat:
		1:
			receivers[3].position = receiverSTORAGE
			shapes[3].position = shapeSTORAGE
			receivers[0].position = receiverPos.global_position
			shapes[0].position = get_local_mouse_position()
		2:
			shapes[0].position = shapeSTORAGE
			receivers[0].position = receiverSTORAGE
			receivers[1].position = receiverPos.global_position
			shapes[1].position = get_local_mouse_position()
		3:
			shapes[1].position = shapeSTORAGE
			receivers[1].position = receiverSTORAGE
			receivers[2].position = receiverPos.global_position
			shapes[2].position = get_local_mouse_position()
		4:
			shapes[2].position = shapeSTORAGE
			receivers[2].position = receiverSTORAGE
			receivers[3].position = receiverPos.global_position
			shapes[3].position = get_local_mouse_position()
