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
@onready var inTimer : Timer = $InTimer
@onready var outTimer : Timer = $OutTimer
var halfBeat : int = 1
var beat : int = 1
var bar : int = 1

#misc var
const shapeSTORAGE = Vector2(-500, 100)
const receiverSTORAGE = Vector2(1400, 200)
var selector : int = 0


func _ready() ->void:
	for s in shapes:
		s.position = shapeSTORAGE
		shapePerf.append(s.get_child(1))
		shapeGreat.append(s.get_child(2))
		shapeOkay.append(s.get_child(3))
		
	for r in receivers:
		r.position = receiverSTORAGE



func _on_in_timer_timeout() -> void:
	#print("bar: ", bar, "beat: ", beat, "half beat: ", halfBeat)
	if halfBeat == 2:
		halfBeat = 1
		beat += 1
		pathFollow.progress += 100
	else:
		halfBeat += 1
	
	if beat == 5:
		beat = 1
		bar += 1



func getScore() -> void:
	pass



func _process(_float) -> void:
	match beat:
		1:
			receivers[3].position = receiverSTORAGE
			shapes[3].position = shapeSTORAGE
			receivers[0].position = receiverPos.global_position
			shapes[0].position = get_global_mouse_position()
		2:
			shapes[0].position = shapeSTORAGE
			receivers[0].position = receiverSTORAGE
			receivers[1].position = receiverPos.global_position
			shapes[1].position = get_global_mouse_position()
		3:
			shapes[1].position = shapeSTORAGE
			receivers[1].position = receiverSTORAGE
			receivers[2].position = receiverPos.global_position
			shapes[2].position = get_global_mouse_position()
		4:
			shapes[2].position = shapeSTORAGE
			receivers[2].position = receiverSTORAGE
			receivers[3].position = receiverPos.global_position
			shapes[3].position = get_global_mouse_position()
