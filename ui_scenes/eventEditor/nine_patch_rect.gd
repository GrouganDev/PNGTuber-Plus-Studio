extends NinePatchRect

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.hoverTextBox = self
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not visible:
		label.text = ""
		label.size = Vector2(1.0, 23.0)
		
	print(label.size)
	resize()
	

func resize():
	self.size.x = label.size.x + label.size.x / 2
	self.size.y = label.size.y + label.size.y / 2
	
	#Updates label's local position RELATIVE to its parent
	label.position = Vector2(size.x / 2 - label.size.x / 2, size.y / 2 - label.size.y / 2)
