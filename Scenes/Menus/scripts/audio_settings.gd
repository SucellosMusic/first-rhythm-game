extends Control

#volume
@onready var volumeSlider : HSlider = $"Volume/Volume Setter"
@onready var volumeDisplay : SpinBox = $"Volume/Volume Setter/Volume Display"

#devices
@onready var deviceSelector : OptionButton = $"Device Selection/Device Options"
@onready var devicesAvailable : Array = AudioServer.get_output_device_list()

func _ready() -> void:
	for da in devicesAvailable:
		deviceSelector.add_item(da)
		
func _on_volume_setter_value_changed(value: float) -> void:
	volumeDisplay.value = value
	AudioServer.set_bus_volume_db(0, value)
	
	if value == -59:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)

func _on_volume_display_value_changed(value: float) -> void:
	volumeSlider.value = value
	

func _on_device_options_item_selected(index: int) -> void:
	AudioServer.set_output_device(devicesAvailable[index])
