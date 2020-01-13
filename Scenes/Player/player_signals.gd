extends "res://Scenes/Player/player.gd"

signal state_changed(current_state)
signal attack_state_changed(current_state)

func _ready():
	pass


func _on_Movement_state_changed(current_state):
	emit_signal("state_changed", current_state.state_name)


func _on_Attack_state_changed(current_state):
	emit_signal("attack_state_changed", current_state.state_name)
