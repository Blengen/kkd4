extends Label

@onready var anim: AnimationPlayer = $anim

func write(new_text: String) -> void:
		text = new_text
		anim.play("RESET")
		anim.play("debug_text")
