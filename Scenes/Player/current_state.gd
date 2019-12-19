extends Label

func _ready():
	pass


func _on_Movement_state_changed(current_state: State):
	text = current_state.state_name
