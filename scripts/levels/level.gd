extends Node2D

@export var next_level_1: String
@export var next_level_2: String
@export var next_level_3: String


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass

func on_body_entered_exit_1(body):
	if body is player:
		get_tree().change_scene_to_file(next_level_1)

func on_body_entered_exit_2(body):
	if body is player:
		get_tree().change_scene_to_file(next_level_2)

func on_body_entered_exit_3(body):
	if body is player:
		get_tree().change_scene_to_file(next_level_3)
