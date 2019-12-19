extends AnimatedSprite

const RIGHT : int = 1
const LEFT : int = -1

var state_name : String = "idle"


func _play_proper_animation() -> void:
	play(state_name)


func _on_Look_Direction_direction_changed(new_direction: int) -> void:
	if new_direction == RIGHT:
		flip_h = false
	elif new_direction == LEFT:
		flip_h = true


func _on_Movement_state_changed(current_state: State) -> void:
	state_name = current_state.state_name
	call_deferred("_play_proper_animation")
