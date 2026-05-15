extends Button

@onready var debug: Label = $"../../../debug"
@onready var desks_node: Control = $"../../../desks"

func _on_pressed() -> void:
	
	var desks: Array[Node] = desks_node.get_children()
	var people: PackedStringArray = $"../../list".text.split("
", false)
	var people_count: int = people.size()

	#region INITIAL CHECKS #
	if not desks:
		debug.write("Generation failed: No desks detected.")
		return
	if not desks.size() == people_count:
		debug.write("Generation failed: Mismatch ("
		+ str(people_count)
		+ " people, "
		+ str(desks.size())
		+ " desks).")
		return
	#endregion END OF CHECKS #
	
	
	for desk in desks:
		var random: int = randi_range(0, people_count - 1)
		var desk_text: Label = desk.find_child("text", false)
		
		desk_text.text = people[random]
		@warning_ignore("integer_division")
		desk_text["theme_override_font_sizes/font_size"] = clamp(450 / desk_text.text.length(), 20, 60)
		desk_text["theme_override_constants/outline_size"] = desk_text["theme_override_font_sizes/font_size"] * 0.1
		people.remove_at(random)
	
		people_count -= 1
