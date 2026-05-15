extends Node

@onready var list: TextEdit = $"../../ui/list"
@onready var desks: Control = $"../../desks"

var desk_scene: PackedScene = preload("res://scenes/desk.tscn")

func _on_list_text_changed() -> void:
	var lines: PackedStringArray = list.text.split("
", false)
	var desks_children: Array[Node] = desks.get_children()
	
	while lines.size() < desks_children.size():
		desks_children[-1].queue_free()
		desks_children.pop_back()
		pass
	
	while lines.size() > desks.get_children().size():
		var new_desk: TextureButton = desk_scene.instantiate()
		desks.add_child(new_desk)
		new_desk.position = Vector2(randi_range(750, 1250), randi_range(250, 750))
