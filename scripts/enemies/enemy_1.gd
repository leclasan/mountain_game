extends Node2D

@onready var front_ray_cast: RayCast2D = $FrontRayCast
@onready var down_ray_cast: RayCast2D = $DownRayCast

var speed = 200
var direction = 1

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if front_ray_cast.is_colliding() or not down_ray_cast.is_colliding():
		scale.x *= -1
		direction *= -1
	else:
		global_position.x += speed * direction * delta


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body is explosive_barrel:
		body.queue_free()
		queue_free()
