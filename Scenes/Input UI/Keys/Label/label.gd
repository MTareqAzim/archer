extends VBoxContainer

export (String) var text


func _ready():
	set_text(text)


func set_text(new_text: String) -> void:
	$Text.text = new_text