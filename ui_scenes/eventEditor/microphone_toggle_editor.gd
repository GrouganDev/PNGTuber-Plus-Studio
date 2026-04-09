extends Node2D

@onready var input = $Buttons/CheckButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.toggleMicEditor = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cancel_button_pressed() -> void:
	visible = false


func _on_confirm_button_pressed() -> void:
	var currentEvent = Global.heldEvent
	var currentSprite = currentEvent.assignedSprite
	
	Global.heldEvent.eventData = input.button_pressed
	currentSprite.microphoneToggles[currentEvent.frameIndex] = currentEvent.eventData
	visible = false
