extends AnimatedSprite

const RIGHT : int = 1
const LEFT : int = -1

export (Array, NodePath) var state_machines

var state_name : String = "idle"
var prev_state : String = "idle"

var _state_machines : Array = []


func _ready() -> void:
	for node_path in state_machines:
		_state_machines.append(get_node(node_path))


func play_previous_state() -> void:
	play(prev_state)
	state_name = prev_state


func _play_proper_animation() -> void:
	if state_name != "shoot":
		prev_state = state_name
	
	if animation == "shoot":
		return
	
	play(state_name)


func _on_Look_Direction_direction_changed(new_direction: int) -> void:
	if new_direction == RIGHT:
		flip_h = false
	elif new_direction == LEFT:
		flip_h = true


func _on_Movement_state_changed(current_state: State) -> void:
	state_name = current_state.state_name
	call_deferred("_play_proper_animation")


func _on_Attack_state_changed(current_state):
	if current_state.state_name != "idle":
		state_name = current_state.state_name
	
	call_deferred("_play_proper_animation")


func _on_AnimatedSprite_animation_finished():
	for state_machine in _state_machines:
		state_machine.on_animation_finished(animation)
