extends Node2D


@onready var optionsContainer = $OptionsContainer/GridContainer
@onready var eventPicker = $EventTypePicker
@onready var audioFileDialog = $SmallerEditWindows/AudioFileDialog

var newRow = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.smallerEditWindows = Global.costumeChangeEditor.get_parent()
	Global.menuItemsContainer = optionsContainer
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if eventPicker.visible == true:
		return

	newRow = Global.menuRowItem.instantiate()
	eventPicker.visible = true
	var event = await eventPicker.optionSelected
	if newRow != null:
		newRow.eventType = event
		optionsContainer.add_child(newRow)
	
	eventPicker.visible = false


func _on_exit_button_pressed() -> void:
	visible = false
