extends Label



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_current_value_label_mouse_entered() -> void:
	print("Mouse hovered")


func _on_current_value_label_mouse_exited() -> void:
	print("Mouse exited")
