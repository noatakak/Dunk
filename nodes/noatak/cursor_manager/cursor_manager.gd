extends CanvasLayer

@export var empty_cursor: Texture = null

func _ready():
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)
	
func _process(delta):
	$Sprite2D.global_position = $Sprite2D.get_global_mouse_position()
