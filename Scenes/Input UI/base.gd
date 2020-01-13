extends Control

onready var crouch_label = $Crouch
onready var pass_through_label = $"Pass Through"
onready var timer = $Timer


func _on_Player_state_changed(current_state):
	if current_state in ["crouch"]:
		pass_through_label.visible = true
		timer.start()
	else:
		pass_through_label.visible = false
		timer.stop()
	
	crouch_label.darken = current_state in ["crouch", "crouch_move", "back_roll"]


func _on_Timer_timeout():
	pass_through_label.visible = false
