extends Control

onready var retreat = $Retreat
onready var back_roll = $"Back Roll"
onready var back_dash = $"Back Dash"
onready var shoot = $Shoot


func _on_Player_state_changed(current_state):
	back_roll.visible = current_state in ["crouch", "crouch_move", "back_roll"]
	back_dash.visible = current_state in ["jump", "high_jump", "fall", "back_dash"]
	
	retreat.darken = current_state == "retreat"
	back_roll.darken = current_state == "back_roll"
	back_dash.darken = current_state == "back_dash"


func _on_Player_attack_state_changed(current_state):
	shoot.darken = current_state == "shoot"
