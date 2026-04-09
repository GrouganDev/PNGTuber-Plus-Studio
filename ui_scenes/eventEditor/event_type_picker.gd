extends Node2D

signal optionSelected

#@onready var window = $Window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_change_costume_button_pressed() -> void:
	optionSelected.emit(Global.eventTypes.CHANGE_COSTUME)


func _on_toggle_microphone_button_pressed() -> void:
	optionSelected.emit(Global.eventTypes.TOGGLE_MICROPHONE)


func _on_play_sound_button_pressed() -> void:
	optionSelected.emit(Global.eventTypes.PLAY_SOUND)


func _on_cancel_button_pressed() -> void:
	var rowItem = get_parent().newRow
	if rowItem != null:
		get_parent().newRow.queue_free()
		get_parent().newRow = null
	visible = false
