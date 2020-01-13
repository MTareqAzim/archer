extends VBoxContainer

onready var text_label = $Text
onready var base = $Text/Base

export (String) var text
export (bool) var darken setget set_darken

const _darken_color = Color(0.46, 0.36, 0, 1)


func _ready():
	set_text(text)


func set_text(new_text: String) -> void:
	text_label.text = new_text


func set_darken(new_darken: bool) -> void:
	if new_darken:
		set_modulate(_darken_color)
	else:
		set_modulate(Color.white)
	
	darken = new_darken