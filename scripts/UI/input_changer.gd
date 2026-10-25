extends HBoxContainer

@onready var action_label: Label = $ActionLabel

@export var action: String

func _ready() -> void:
	action_label.text = action


func _process(delta: float) -> void:
	pass


func _on_add_key_button_pressed() -> void:
	pass # Replace with function body.


func _on_remove_keys_button_pressed() -> void:
	InputMap.action_erase_events(action)
