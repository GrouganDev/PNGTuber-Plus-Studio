extends ColorRect

signal editButtonPressed

@onready var label = $HBoxContainer/EventTypeLabel/Label

@onready var frameInput = $HBoxContainer/Control/LineEdit

@onready var valueLabel = $HBoxContainer/CurrentValueLabel/Label

var eventType = null

var frameIndex = null

var eventData = null

var cleanText = null

var assignedSprite = null

var audioFileDialogue = null

var audioPlayer = null

var hoveredMousePos = null
var hovered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	valueLabel.mouse_filter = Control.MOUSE_FILTER_PASS
	assignedSprite = Global.heldSprite
	
	Input.set_use_accumulated_input(true)
	
	match eventType:
		Global.eventTypes.CHANGE_COSTUME:
			label.text = "Change Costume"
		Global.eventTypes.TOGGLE_MICROPHONE:
			label.text = "Toggle Microphone"
		Global.eventTypes.PLAY_SOUND:
			label.text = "Play Sound"
			#audioFileDialogue = get_parent().get_parent().get_parent().get_child(0).get_child(2)
			#audioFileDialogue.file_selected.connect(_on_audio_file_selected)
			
			#audioFileDialogue.close_requested.connect(_on_audio_close_requested)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cleanText = frameInput.text
	
	visible = (Global.heldSprite == assignedSprite)
	
	updateValueLabel()
	
	#if showFullEventContents:
		##await get_tree().create_timer(1).timeout
		#Global.hoverTextBox.label.text = valueLabel.text
		#Global.hoverTextBox.global_position = get_global_mouse_position()
		#Global.hoverTextBox.visible = true
	#else:
		#Global.hoverTextBox.visible = false

func updateValueLabel():
	#valueLabel.text = str(eventData)
	match eventType:
		Global.eventTypes.CHANGE_COSTUME:
			valueLabel.text = "Current Value:\n" + str(eventData)
		Global.eventTypes.TOGGLE_MICROPHONE:
			valueLabel.text = "Current Value:\n"+ str(eventData)
		Global.eventTypes.PLAY_SOUND:
			#var fileNames = eventData[1].split("/")
			valueLabel.text = "Current Value:\n"+ str(eventData[1])


func _on_delete_button_pressed() -> void:
	if is_instance_valid(eventData):
		eventData.queue_free()

	if Global.heldEvent == self:
		Global.heldEvent = null
		
	
	match eventType:
		Global.eventTypes.CHANGE_COSTUME:
			assignedSprite.costumeChanges.erase(frameIndex)
		Global.eventTypes.TOGGLE_MICROPHONE:
			assignedSprite.microphoneToggles.erase(frameIndex)
		Global.eventTypes.PLAY_SOUND:
			assignedSprite.soundToggles.erase(frameIndex)
	
	for window in Global.smallerEditWindows.get_children():
		if window.visible:
			window.visible = false

	queue_free()
	


func _on_edit_button_pressed() -> void:
	for window in Global.smallerEditWindows.get_children():
		if window.visible:
			return

	Global.heldEvent = self
	match eventType:
		Global.eventTypes.CHANGE_COSTUME:
			Global.costumeChangeEditor.visible = true
		Global.eventTypes.TOGGLE_MICROPHONE:
			Global.toggleMicEditor.visible = true
		Global.eventTypes.PLAY_SOUND:
			#audioFileDialogue.show()
			Global.main.audioDialog.show()


func _on_line_edit_text_changed(new_text: String) -> void:
	sanitizeText(new_text)
	
	Global.heldEvent = self
	var newFrame = (frameInput.text)
	match eventType:
		Global.eventTypes.CHANGE_COSTUME:
			changeEventMapPosition(newFrame, assignedSprite.costumeChanges)
		
		Global.eventTypes.TOGGLE_MICROPHONE:
			changeEventMapPosition(newFrame, assignedSprite.microphoneToggles)
		
		Global.eventTypes.PLAY_SOUND:
			changeEventMapPosition(newFrame, assignedSprite.soundToggles)

func sanitizeText(text):
	if text.is_valid_int() and (int)(text) <= 64 and (int)(text) >= 1:
		return
	elif text == "":
		return
	else:
		var pos = frameInput.caret_column
		frameInput.text = cleanText
		frameInput.caret_column = pos

func changeEventMapPosition(newFrame, eventMap):
	if frameInput.text == "":
		eventMap.erase(frameIndex)
		frameIndex = null
		return
	
	if newFrame != frameIndex:
		eventMap[newFrame] = eventData
		eventMap.erase(frameIndex)
		frameIndex = newFrame

func _on_audio_file_selected(path: String):
	
	if is_instance_valid(eventData):
		eventData.queue_free()
	
	audioPlayer = AudioStreamPlayer.new()
	
	var extension = (path.substr(len(path) - 3)).to_lower()
	match extension:
		"wav":
			audioPlayer.stream = AudioStreamWAV.load_from_file(path)
		"ogg":
			audioPlayer.stream = AudioStreamOggVorbis.load_from_file(path)
		"mp3":
			audioPlayer.stream = AudioStreamMP3.load_from_file(path)
	audioPlayer.volume_db = 0
	audioPlayer.pitch_scale = 1
	audioPlayer.bus = "Master"
	
	Global.main.add_child(audioPlayer)
	
	eventData = [audioPlayer, path]
	
	if frameInput.text != "":
		assignedSprite.soundToggles[frameIndex] = eventData

#func _on_audio_close_requested():
	#audioFileDialogue.hide()

func _input(event: InputEvent) -> void:
	if hovered and Input.is_action_just_pressed("mouse_left"):
		Global.hoverTextBox.label.text = valueLabel.text
		Global.hoverTextBox.global_position = get_global_mouse_position()
		Global.hoverTextBox.visible = true

func _on_label_mouse_entered() -> void:
	hovered = true
	#Global.hoverTextBox.label.text = valueLabel.text
	#Global.hoverTextBox.global_position = get_global_mouse_position()
	#Global.hoverTextBox.visible = true


func _on_label_mouse_exited() -> void:
	hovered = false
	Global.hoverTextBox.label.size = Vector2(0,0)
	Global.hoverTextBox.visible = false
