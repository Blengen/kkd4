extends Node

@onready var desk: Node = $"../.."

var held_down: bool = false

func _ready() -> void:
	if not desk.button_down.has_connections():
		desk.button_down.connect(func(): held_down = true)
	if not desk.button_up.has_connections():
		desk.button_up.connect(func(): held_down = false)

func _input(event: InputEvent) -> void:
	if not held_down: return
	
	if event is InputEventMouseMotion:
		desk.position += Vector2(event.relative.x, event.relative.y)
