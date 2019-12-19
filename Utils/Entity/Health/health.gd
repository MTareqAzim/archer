extends Node
class_name Health, "health.png"

signal health_changed(health)
signal healed
signal damaged

export (int, 0, 2147483647) var max_health

onready var _health : int = max_health setget _set_health, get_health


func heal_health(amount: int) -> void:
	if amount > 0:
		_set_health(_health + amount)
		emit_signal("healed")


func damage_health(amount: int) -> void:
	if amount > 0:
		_set_health(_health - amount)
		emit_signal("damaged")


func _set_health(new_health: int) -> void:
	var previous_health = _health
	_health = int(clamp(new_health, 0, max_health))
	
	if _health != previous_health:
		emit_signal("health_changed", _health)


func get_health() -> int:
	return _health
