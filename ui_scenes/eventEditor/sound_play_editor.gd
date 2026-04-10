extends Node2D

@onready var filePathInput = $FilepathInput/Input
@onready var volumeSlider = $VolumeControl/HSlider
@onready var volumeLabel = $VolumeControl/VolumeLevel
@onready var collisionShape = $Area2D/CollisionShape2D


var filePath = null

var volume = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.playSoundEditor = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(Global.heldEvent)
	filePath = filePathInput.text
	volume = volumeSlider.value
	volumeLabel.text = "Volume: " + str(volume) + " dB"
	
	collisionShape.disabled = !visible

func _on_browse_button_pressed() -> void:
	Global.main.audioDialog.show()


func _on_cancel_button_pressed() -> void:
	visible = false


func _on_confirm_button_pressed() -> void:
	Global.heldEvent.setUpAudioEvent(filePath, volume)
	visible = false
