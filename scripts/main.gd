extends Node2D

@onready var cline: LineEdit = $ui/command_line # We have asked the question
@onready var list_label: Label = $ui/list_label
@onready var desks: Control = $desks

var people: Array = []
var desk_instance: Node
var desk_node: PackedScene = preload("res://scenes/desk.tscn")
var desk_size = Vector2(0.75, 0.75)
var hidden_mode = false

func _ready() -> void:
	cline.grab_focus()
	
func _on_command_line_text_submitted(command: String) -> void:
	var command_lower = command.to_lower() # Make Lowercase
	
	cline.clear()

	if command_lower.begins_with("add"):
		if command.find(" ") == -1:
			message("You need a name after \"add\" (example: add Alice Glee)")
			return
		else:
			
			#cline.text = "add "
			
			var person = command.substr(4)
			people.append(person)
			add_desk()
	elif command_lower.begins_with("remove"):
		
		if command.find(" ") == -1:
			message("You need a name or number after \"remove\" (example: remove Alice Glee)")
			return
		
		#cline.text = "remove "
		
		var person = command.substr(7)
		
		if person.is_valid_int():
			if people.has(person): 
				people.erase(person)
				remove_desk()
			else:
				person = int(person)
				
				if people.size() < person:
					message("List does not contain this many people")
					return
				people.remove_at(person - 1)
				remove_desk()


		else:
			# Check case sensitive
			if people.has(person):
				people.erase(person)
				remove_desk()
				update_label()
				return
			
			else:
				# Check case insensitive
				var index = 0
				for _person in people:
					if _person.to_lower() == person.to_lower():
						people.pop_at(index)
						remove_desk()
						update_label()
						return
					else: index += 1
				
			# Check if input was number or name, to tell user which one failed.
				if person.is_valid_int(): message("Number higher than amount of people in list")
				else: message("Name not found in list. Check your spelling.")
				
	elif command_lower.begins_with("desksize"):
		
		if command.find(" ") == -1:
			message("You need a number after \"desksize\" (0.25 to 1.5 are good)")
			return
		
		var value = command.substr(9)
		if value.is_valid_float():
			value = value.to_float()
			value = clamp(value, 0.05, 2)
			desk_size = Vector2(value, value)
			for child in desks.get_children(): child.scale = desk_size
		else: message("Value is not a number")
		
		
		
	elif command_lower.begins_with("make"):
		
		if people.size() == 0:
			message("Can't generate map, empty room")
			return
		
		var remaining_people: Array = people.duplicate()
		var random_person: String = ""
		var list_length = remaining_people.size()
		
		for child in desks.get_children():
			
			var pick = randi_range(0, list_length-1)
			random_person = remaining_people[pick]
			child.desk_text.text = random_person
			
			child.text_size.scale = Vector2(1, 1)
			if random_person.length() > 10: child.text_size.scale = Vector2(0.6, 0.6)
			if random_person.length() > 20: child.text_size.scale = Vector2(0.35, 0.35)
			
			
			remaining_people.pop_at(pick)
			list_length -= 1
	
	elif command_lower.begins_with("showlist"): list_label.visible = !list_label.visible

	elif command_lower.begins_with("hide"):
		
		if hidden_mode == false:
			for child in desks.get_children():
				child.hidden_mode = true
				child.desk_text.hide()
			hidden_mode = true
		else:
			for child in desks.get_children():
				child.hidden_mode = false
				child.desk_text.show()
			hidden_mode = false
			


	else: message("Unknown command, check your spelling.")
		
		
	update_label()
			
func message(value):
	print(value)
	$ui/debug.text = "Debug: " + value
	$ui/debug.show()
	$ui/debug/debug_timer.start()

func update_label():
	list_label.text = ""
	for person in people:
		list_label.text += person
		list_label.text += "
		"

func add_desk():
	var instance = desk_node.instantiate()
	instance.scale = desk_size
	instance.hidden_mode = hidden_mode
	instance.position = Vector2(200, 200)
	desks.add_child(instance)

func remove_desk():
	var desk_child = desks.get_child(0)
	desks.remove_child(desk_child)
	desk_child.queue_free()


func _on_debug_timer_timeout() -> void: $ui/debug.hide()
