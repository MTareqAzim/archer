extends Position2D

enum Aim {HIGH, MID, LOW}

const arrow_packed_scene = preload("res://Scenes/Arrow/arrow.tscn")
const OFFSET = 10

export (NodePath) var look_direction
export (NodePath) var aim
export (NodePath) var player_input

export (float) var HIGH := -0.9
export (float) var MID := -0.2
export (float) var LOW := 0.5

onready var _look_direction : LookDirection = get_node(look_direction)
onready var _aim = get_node(aim)
onready var _player_input : PlayerInputHandler = get_node(player_input)

var _arrow : KinematicBody2D = null

func _ready() -> void:
	pass


func shoot_arrow() -> void:
	_spawn_arrow()
	var direction = _get_shoot_direction()
	_position_arrow(direction)
	_shoot(direction)
	_arrow = null


func _spawn_arrow() -> void:
	if _arrow == null:
		_arrow = arrow_packed_scene.instance()
		get_tree().current_scene.add_child(_arrow)


func _position_arrow(direction: Vector2) -> void:
	_arrow.global_transform = global_transform
	_arrow.position.x += sign(direction.x) * OFFSET


func _shoot(direction: Vector2) -> void:
	_arrow.shoot(direction)


func _get_shoot_direction() -> Vector2:
	var direction := Vector2()
	var aim : int = _aim.get_aim()
	var look_dir : int = _aim.get_aim_direction()
	
	_look_direction.set_look_direction(look_dir)
	
	if aim == Aim.HIGH:
		direction = Vector2(look_dir, HIGH).normalized()
	elif aim == Aim.LOW:
		direction = Vector2(look_dir, LOW).normalized()
	else:
		direction = Vector2(look_dir, MID).normalized()
	
	return direction
