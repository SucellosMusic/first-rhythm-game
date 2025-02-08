extends Node2D

@onready var receiverOutline = $"Receiver Outline"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	receiverOutline.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_float) -> void:
	pass
