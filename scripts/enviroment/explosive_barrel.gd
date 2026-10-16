extends RigidBody2D

class_name explosive_barrel

var player_impulse_force = 750

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if body is player:
		for i in body.get_slide_collision_count():
			var c = body.get_slide_collision(i)
			if c.get_collider() == self:
				self.apply_central_impulse(-c.get_normal() * player_impulse_force)
