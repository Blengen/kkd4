extends Button

@onready var debug: Label = $"../../../debug"
@onready var desks_node: Control = $"../../../desks"

func _on_pressed() -> void:
	
	var file: String = ""
	
	var desks: Array[Node] = desks_node.get_children()
	var people: PackedStringArray = $"../../list".text.split("
", false)
	var people_count: int = people.size()

	#region INITIAL CHECKS #
	if not desks:
		debug.write("Copy Failed: No desks detected (Empty Room).")
		return
	if not desks.size() == people_count:
		debug.write("Copy Failed: Mismatch ("
		+ str(people_count)
		+ " people, "
		+ str(desks.size())
		+ " desks).")
		return
	#endregion END OF CHECKS #
	
	for person: String in people: file += person + "
"
	file += "
§
"
	for desk: Node in desks:
		file += str(int(desk.position.x)) + ","
		file += str(int(desk.position.y)) + "
"

		DisplayServer.clipboard_set(file)
		debug.write("Copied Successfully")
