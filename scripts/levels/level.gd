extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var player: player = $Player
@onready var camera: Camera2D = $Camera2D

@export var next_level_1: String
@export var next_level_2: String
@export var next_level_3: String

@export var camera_movement = 0 # 0 = no movement, 1 = y movement, 2 = x movement, 3 = y + x movement


func _ready() -> void:
	camera.limit_left = 0
	camera.limit_right = 1152
	camera.limit_top = 0
	camera.limit_bottom = 648
	camera.position = Vector2(576,324)
	if camera_movement == 1:
		set_camera_y_boundaries()
	if camera_movement == 2:
		set_camera_x_boundaries()
	if camera_movement == 3:
		set_camera_x_boundaries()
		set_camera_y_boundaries()


func _process(delta: float) -> void:
	if camera_movement != 0:
		camera.position = player.position


func on_body_entered_exit_1(body):
	if body is player:
		get_tree().call_deferred("change_scene_to_file", next_level_1)

func on_body_entered_exit_2(body):
	if body is player:
		get_tree().call_deferred("change_scene_to_file", next_level_2)

func on_body_entered_exit_3(body):
	if body is player:
		get_tree().call_deferred("change_scene_to_file", next_level_3)

func set_camera_y_boundaries():
	var tile_rect = tile_map.get_used_rect()
	camera.limit_top = tile_map.map_to_local(Vector2i(tile_rect.position)).y * tile_map.scale.y

func set_camera_x_boundaries():
	var tile_rect = tile_map.get_used_rect()
	camera.limit_top = tile_map.map_to_local(Vector2i(tile_rect.position)).x * tile_map.scale.x
