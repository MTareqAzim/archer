extends Control

onready var jump_label = $Jump
onready var high_jump_label = $"High Jump"

func _on_Player_state_changed(current_state):
	if current_state in ["crouch", "crouch_move", "high_jump"]:
		high_jump_label.visible = true
	elif current_state in ["fall", "back_dash"]:
		pass
	else:
		high_jump_label.visible = false
	
	high_jump_label.darken = current_state in ["high_jump", "fall", "back_dash"]
	jump_label.darken = current_state in ["jump", "fall", "back_dash"]
