extends Node2D

@onready var front_ray_cast: RayCast2D = $FrontRayCast
@onready var down_ray_cast: RayCast2D = $DownRayCast
@onready var player_ray_cast: RayCast2D = $PlayerRayCast
@onready var floor_ray_cast: RayCast2D = $FloorRayCast
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum States {IDLE, RUNNING, NULL}
@export var state = States.IDLE

var speed = 200
var running_speed = 575
var direction = 1

var gravity = 100

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match state:
		States.IDLE:
			if front_ray_cast.is_colliding() or not down_ray_cast.is_colliding():
				scale.x *= -1
				direction *= -1
			elif player_ray_cast.is_colliding():
				animation_player.play("enrage_animation")
			else:
				global_position.x += speed * direction * delta
		States.RUNNING:
			if front_ray_cast.is_colliding():
				animation_player.play("RESET")
			else:
				global_position.x += running_speed * direction * delta
	if not floor_ray_cast.is_colliding():
		position.y += gravity * delta

func _on_area_body_entered(body: Node2D) -> void:
		queue_free()
