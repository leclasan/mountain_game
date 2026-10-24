extends CharacterBody2D

class_name player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var rope_detect: RayCast2D = $RopeDetect

const  speed = 4750
const  speed_cap = 600
const  jump_speed = -630
var jump_buffer = 0.0
const buffer_time = 65
var last_time_walking = 0.0
var last_time_on_wall = 0.0
const walljump_speed = -630
const  walljump_x_speed = 1000
var walljump_dir = 0

const  gravity = 1900
const fall_velocity_cap = 3000
enum States {WALKING, FALLING, JUMP, WALLJUMP, ROPE} 
var state = States.FALLING

var rope_pos = Vector2.ZERO
var rope_speed = 750.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	rope_detect_rotate()
	
	move()
	
	move_and_slide()

func move():
	match state:
		States.WALKING:
			if Input.is_action_just_pressed("jump") or (Time.get_ticks_msec() - jump_buffer) <= buffer_time:
				state = States.JUMP
			elif not is_on_floor():
				last_time_walking = Time.get_ticks_msec()
				state = States.FALLING
			walljump_dir = 0
			
			var direction = Input.get_axis("left", "right")
			
			if direction:
				animated_sprite.play("walking")
				if velocity.x < 0:
					animated_sprite.flip_h = true
				else:
					animated_sprite.flip_h = false
				
				velocity.x +=  direction * speed * get_process_delta_time()
				if velocity.x > speed_cap:
					velocity.x = speed_cap
				if velocity.x < -speed_cap:
					velocity.x = -speed_cap
			else:
				animated_sprite.play("idle")
				
				velocity.x = 0
		States.FALLING:
			if Input.is_action_just_pressed("jump"):
				if (Time.get_ticks_msec()-last_time_walking) <= 50:
					state = States.JUMP
				else:
					jump_buffer = Time.get_ticks_msec()
			if is_on_floor():
				state = States.WALKING
			elif (is_on_wall() or (Time.get_ticks_msec() - last_time_on_wall <= 75)) and (Input.is_action_just_pressed("jump") or (Time.get_ticks_msec() - jump_buffer) <= buffer_time):
				state = States.WALLJUMP
			else:
				velocity.y += gravity * get_process_delta_time()
				if velocity.y > fall_velocity_cap:
					velocity.y = fall_velocity_cap
			if is_on_wall():
				walljump_dir = 0
				last_time_on_wall = Time.get_ticks_msec()
			
			var direction = Input.get_axis("left", "right")
			
			if direction and sign(direction) != walljump_dir:
				if abs(velocity.x) < speed_cap:
					velocity.x +=  direction * speed * get_process_delta_time()
					if velocity.x > speed_cap:
						velocity.x = speed_cap
					if velocity.x < -speed_cap:
						velocity.x = -speed_cap
				else:
					velocity.x = move_toward(velocity.x, 0, get_process_delta_time()*speed)
			else:
				velocity.x = move_toward(velocity.x, 0, get_process_delta_time()*speed)
			
			animated_sprite.play("falling")
			if velocity.x < 0:
				animated_sprite.flip_h = true
			else:
				animated_sprite.flip_h = false
			
		States.JUMP:
			jump_buffer = 0
			velocity.y = jump_speed
			state = States.FALLING
		States.WALLJUMP:
			jump_buffer = 0
			velocity.y = walljump_speed
			velocity.x = walljump_x_speed * sign(get_wall_normal().x)
			walljump_dir = -sign(get_wall_normal().x)
			state = States.FALLING
		States.ROPE:
			position.x = move_toward(position.x, rope_pos.x, rope_speed * get_process_delta_time())
			position.y = move_toward(position.y, rope_pos.y, rope_speed * get_process_delta_time())
			if position >= rope_pos - Vector2(5, 5) and position <= rope_pos + Vector2(5, 5):
				state = States.FALLING
			velocity = Vector2.ZERO

func rope_detect_rotate():
	var rope_direction = Input.get_vector("left", "right", "up", "down")
	if (rope_direction.x != 0.0) and (rope_direction.y != 0.0):
		rope_direction = sign(rope_direction) * Vector2(100000,100000)
	else:
		rope_direction = sign(rope_direction) * Vector2(100000, 100000) * global_position
	if rope_direction:
		rope_detect.look_at(rope_direction)
	if Input.is_action_just_pressed("rope"):
		if rope_detect.is_colliding():
			rope_pos = rope_detect.get_collision_point()
			state = States.ROPE


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bounce"):
		if Input.is_action_pressed("jump"):
			velocity.y = jump_speed * 1.35
		else:
			velocity.y = jump_speed 
		state = States.FALLING
