extends Node2D

@onready var animationControl = self.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationControl.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
