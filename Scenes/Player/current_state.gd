extends Label

func _ready():
	pass


func _on_Movement_state_changed(current_state: State):
	text = current_state.state_name


func _on_Attack_state_changed(current_state):
	text = current_state.state_name


func _on_AnimatedSprite_animation_changed(anim):
	text = anim
