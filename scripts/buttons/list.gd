extends TextEdit

@onready var desks: Control = $"../../desks"
var desk_scene: PackedScene = preload("res://scenes/desk.tscn")

func _on_text_changed() -> void:
	if not text.contains("\n§\n"): return
	
	var sections: PackedStringArray = text.split("\n§\n")

	print(sections)

	text = sections[0]
	await get_tree().process_frame
	for desk in $"../../desks".get_children(): desk.queue_free()
	await get_tree().process_frame

	var desks_pos: PackedStringArray = sections[1].split("\n", false)
	
	for pos in desks_pos:
		var poses: PackedStringArray = pos.split(",")
		var new_desk: TextureButton = desk_scene.instantiate()
		
		desks.add_child(new_desk)
		new_desk.position.x = poses[0].to_int()
		new_desk.position.y = poses[1].to_int()
