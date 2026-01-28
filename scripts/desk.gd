extends Control

#@onready var button = $button
@onready var text_size = $button/text_pivot
@onready var desk_text = $button/text_pivot/text

var clicked = false
var hidden_mode: bool = false
	
func _input(event: InputEvent) -> void:
	if clicked and event is InputEventMouseMotion and Input.is_action_pressed("lmb"):
		position.x += event.relative.x
		position.y += event.relative.y
	
	clamp_desk_pos()

func clamp_desk_pos():
	position.x = clamp(position.x, -30.0, 1830)
	position.y = clamp(position.y, 80.0, 890.0)
	pass


func _on_button_down() -> void:
	clicked = true
	if hidden_mode: desk_text.show()
func _on_button_up() -> void:
	clicked = false
	if hidden_mode: desk_text.hide()


func _on_loadtimer_timeout() -> void: desk_text.visible = !hidden_mode
