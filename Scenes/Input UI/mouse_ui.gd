extends Control

onready var retreat = $Retreat
onready var back_roll = $"Back Roll"
onready var back_dash = $"Back Dash"


func _on_Player_state_changed(current_state):
	back_roll.visible = current_state in ["crouch", "crouch_move", "back_roll"]
	back_dash.visible = current_state in ["jump", "high_jump", "fall", "back_dash"]
