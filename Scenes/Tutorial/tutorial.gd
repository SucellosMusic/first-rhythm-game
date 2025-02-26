extends Node2D

#buttons
@onready var next : Button = $Next
@onready var previous : Button = $Previous

#scenes
@onready var welcome : Control = $Welcome
@onready var intros : Array = $"Shapes, Receivers, and Hints".get_children()
@onready var paths : Control = $Paths
@onready var survival : Control = $Survival

#shape scenes
@onready var shapes : Array = $"Assigned Shapes".get_children()
@onready var receivers : Array = $Receivers.get_children()
@onready var altReceivers : Array = $"Alt Receivers".get_children()
@onready var hints : Array = $Hints.get_children()
var shapeSelect : int = 0
var prevShape : int;
var shapeStorage  = Vector2(-500, 150)
var receiverStorage = Vector2(-500, 400)
var hintStorage = Vector2(-500, 650)
var altReceiverStorage = Vector2(-500, 900)

#misc
@onready var sceneCounter : int = 0;
var shapesActive : bool;

func _ready() -> void:
	for i in intros:
		i.visible = false
	
	paths.visible = false
	survival.visible = false
	to_scene()

func cycle_shapes() -> void:
	prevShape = shapeSelect
	if Input.is_action_just_pressed("Input Shape"):
		if shapeSelect == 6:
			shapeSelect = 0
		else:
			shapeSelect += 1

func place_receivers() -> void:
	receivers[0].position = Vector2(150, 150)
	receivers[1].position = Vector2(250, 350)
	receivers[2].position = Vector2(450, 550)
	receivers[3].position = Vector2(550, 200)
	receivers[4].position = Vector2(650, 550)
	receivers[5].position = Vector2(900, 350)
	receivers[6].position = Vector2(1000, 150)

func store_receivers() -> void:
	for r in receivers:
		r.position = receiverStorage

func place_hints() -> void:
	hints[0].position = Vector2(150, 150)
	hints[1].position = Vector2(250, 350)
	hints[2].position = Vector2(450, 550)
	hints[3].position = Vector2(550, 300)
	hints[4].position = Vector2(650, 550)
	hints[5].position = Vector2(900, 350)
	hints[6].position = Vector2(1000, 150)

func store_hints() -> void:
	for h in hints:
		h.position = hintStorage
		

func place_example_paths() ->void:
	receivers[0].position = Vector2(750, 500)
	hints[0].position = Vector2(950, 500)
	altReceivers[0].position = Vector2(200, 450)
	altReceivers[0].rotation_degrees = -45
	
func store_example_paths() -> void:
	receivers[0].position = receiverStorage
	hints[0].position = hintStorage
	altReceivers[0].position = altReceiverStorage
	altReceivers[0].rotation_degrees = 0
	

func to_scene() -> void:
	match sceneCounter:
		0:
			welcome.visible = true
			intros[0].visible = false
			previous.disabled = true
		1:
			welcome.visible = false 
			intros[0].visible = true
			intros[1].visible = false
			previous.disabled = false
		2:
			store_receivers()
			shapesActive = true
			intros[0].visible = false
			intros[1].visible = true
			intros[2].visible = false
		3:
			place_receivers()
			store_hints()
			intros[1].visible = false
			intros[2].visible = true
			intros[3].visible = false
		4:
			store_example_paths()
			store_receivers()
			place_hints()
			intros[2].visible = false
			intros[3].visible = true
		5:
			store_hints()
			place_example_paths()
			intros[3].visible = false
			paths.visible = true
			survival.visible = false
			next.disabled = false
		6:
			store_example_paths()
			survival.visible = true
			paths.visible = false
			next.set_text("Back to Menu")

func _on_next_pressed() -> void:
	if sceneCounter <= 6:
		sceneCounter += 1
		to_scene()
	if sceneCounter > 6:
		get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")

func _on_previous_pressed() -> void:
	if sceneCounter >= 0:
		sceneCounter  -= 1
		to_scene()

func _process(delta: float) -> void:
	cycle_shapes()
	if (sceneCounter == 2 || sceneCounter == 3) && shapesActive == true:
		shapes[prevShape].position = shapeStorage
		shapes[shapeSelect].position = get_global_mouse_position()
	else:
		shapes[shapeSelect].position = shapeStorage


func _on_next_mouse_entered() -> void:
	shapesActive = false
func _on_next_mouse_exited() -> void:
	shapesActive = true
func _on_previous_mouse_entered() -> void:
	shapesActive = false
func _on_previous_mouse_exited() -> void:
	shapesActive = true
