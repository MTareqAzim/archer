extends Position2D

const arrow_packed_scene = preload("res://Scenes/Arrow/arrow.tscn")
const OFFSET = 20
const HIGH = -0.9
const MID = -0.2
const LOW = 0.4

export (NodePath) var look_direction : NodePath
export (NodePath) var player_input : NodePath

onready var _look_direction : LookDirection = get_node(look_direction)
onready var _player_input : PlayerInputHandler = get_node(player_input)

var _arrow : KinematicBody2D = null

func _ready() -> void:
	pass


func shoot_arrow() -> void:
	_spawn_arrow()
	_position_arrow()
	_shoot()
	_arrow = null


func _spawn_arrow() -> void:
	if _arrow == null:
		_arrow = arrow_packed_scene.instance()
		get_tree().current_scene.add_child(_arrow)


func _position_arrow():
	_arrow.global_transform = global_transform
	_arrow.position.x += _look_direction.get_look_direction() * OFFSET


func _shoot() -> void:
	var direction : Vector2 = _get_shoot_direction()
	_arrow.shoot(direction)


func _get_shoot_direction() -> Vector2:
	var direction := Vector2()
	var look_dir : int = _look_direction.get_look_direction()
	
	var aim : int = int(_player_input.is_action_pressed("high")) - int(_player_input.is_action_pressed("low"))
	
	if aim == 1:
		direction = Vector2(look_dir, HIGH).normalized()
	elif aim == -1:
		direction = Vector2(look_dir, LOW).normalized()
	else:
		direction = Vector2(look_dir, MID).normalized()
	
	return direction