extends Node2D

@onready var input = $Input

@onready var confirm = $Buttons/ConfirmButton

var cleanText = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.costumeChangeEditor = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	confirm.disabled = (input.text == "")


func _on_cancel_button_pressed() -> void:
	visible = false
	input.text = ""


func _on_confirm_button_pressed() -> void:
	var currentEvent = Global.heldEvent
	var currentSprite = currentEvent.assignedSprite
	
	currentEvent.eventData = (int)(input.text)
	currentSprite.costumeChanges[currentEvent.frameIndex] = currentEvent.eventData
	visible = false
	input.text = ""


func _on_input_text_changed(new_text: String) -> void:
	sanitizeText(new_text)
	cleanText = input.text

func sanitizeText(text):
	if !text.is_valid_int() and text != "":
		input.text = cleanText
	elif text != "":
		var pos = input.caret_column
		input.text = str(wrapi((int)(input.text), 1, 11))
		input.caret_column = pos
