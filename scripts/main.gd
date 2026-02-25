extends Node2D

@onready var cline: LineEdit = $ui/command_line # We have asked the question
@onready var list_label: Label = $ui/list_scroll_container/list_label
@onready var desks: Control = $desks

var people: Array = []
var desk_node: PackedScene = preload("res://scenes/desk.tscn")
var desk_size = Vector2(0.75, 0.75)
var hidden_mode = false

func _ready() -> void:
	cline.grab_focus()

# Command line parser
func do_command(command: String) -> void:
	var command_lower = command.to_lower() # Make Lowercase
	
	if not command.contains("noclear"): cline.clear()

	if command_lower.begins_with("add"):
		if command.find(" ") == -1:
			message("You need a name after \"add\" (example: add Alice Glee)")
			return
		else:
			
			#cline.text = "add "
			
			var person = command.substr(4)
			people.append(person)
			add_desk()
			cline.insert_text_at_caret("add ")
			
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
				cline.insert_text_at_caret("remove ")


		else:
			# Check case sensitive
			if people.has(person):
				people.erase(person)
				remove_desk()
				update_label()
				cline.insert_text_at_caret("remove ")
				return
			
			else:
				# Check case insensitive
				var index = 0
				for _person in people:
					if _person.to_lower() == person.to_lower():
						people.pop_at(index)
						remove_desk()
						update_label()
						cline.insert_text_at_caret("remove ")
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
		
		$ui/buttons/buttons_middle/desk_size.text = "Desk size: " + str(snapped(value, 0.01))
		
		
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
			
			child.desk_text.scale = Vector2(1, 1)
			if random_person.length() > 10: child.desk_text.scale = Vector2(0.6, 0.6)
			if random_person.length() > 20: child.desk_text.scale = Vector2(0.35, 0.35)
			
			
			remaining_people.pop_at(pick)
			list_length -= 1
			
	
	elif command_lower.begins_with("showlist"):
		list_label.visible = !list_label.visible
		if list_label.visible: $ui/buttons/buttons_middle/show_list.text = "Show List (on)"
		else: $ui/buttons/buttons_middle/show_list.text = "Show List (off)"

	elif command_lower.begins_with("hide"):
		
		if hidden_mode == false:
			for child in desks.get_children():
				child.hidden_mode = true
				child.desk_text.hide()
			hidden_mode = true
			$ui/buttons/buttons_middle/hidden.text = " Hidden (on) "
		else:
			for child in desks.get_children():
				child.hidden_mode = false
				child.desk_text.show()
			hidden_mode = false
			$ui/buttons/buttons_middle/hidden.text = " Hidden (off) "
	
	elif command.begins_with("saveas"):
		
		if desks.get_children().size() == 0:
			message("bromo sapien tryna save an empty map")
			return
		
		var names_backup: Array[String] = []
		for child in desks: names_backup.append(child.desk_text.text) # Text will be deleted temporarily
		for child in desks: child.desk_text.text = "" # IDK why it's green like that

		$desks.people = people
		$desks.desk_size = desk_size
		
		$save_dialog.show()

	else: message("Unknown command, check your spelling.")
		
		
	update_label()
			
func message(value):
	print(value)
	$ui/debug.text = "Debug: " + value
	$ui/debug.show()
	$ui/debug/debug_timer.start()

func update_label():
	list_label.text = ""
	var _index: int = 1
	
	for person in people:
		list_label.text += str(_index)
		list_label.text += ": "
		list_label.text += person
		if not _index == people.size(): list_label.text += "
		"
		_index += 1
		
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


func _on_add_pressed() -> void:
	cline.text = ""
	cline.insert_text_at_caret("add ")

func _on_remove_pressed() -> void:
	cline.text = ""
	cline.insert_text_at_caret("remove ")
	
func _on_desk_size_pressed() -> void:	
	cline.text = ""
	cline.insert_text_at_caret("desksize ")

func _on_generate_pressed() -> void: do_command("make noclear")
func _on_hidden_pressed() -> void: do_command("hide noclear")
func _on_show_list_pressed() -> void: do_command("showlist noclear")


func _on_save_as_pressed() -> void: do_command("saveas noclear")
