extends EntityStateComponent

export (String) var collider_key
export (int) var crouch_height := 50

var _collider : CollisionShape2D


func enter() -> void:
	$"Enter Height".args = [crouch_height]
	$"Exit Height".args = [_collider.get_height()]


func assign_dependencies() -> void:
	_collider = component_state.get_dependency(collider_key)