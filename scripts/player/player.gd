extends CharacterBody2D

class_name player

@onready var rope_detect: RayCast2D = $RopeDetect

const  speed = 4750
const  speed_cap = 600
const  jump_speed = -630
var jump_buffer = 0.0
const buffer_time = 65
const walljump_speed = -630
const  walljump_x_speed = 1000
var walljump_dir = 0

const  gravity = 1900
const fall_velocity_cap = 3000
enum States {WALKING, FALLING, JUMP, WALLJUMP} 
var state = States.FALLING

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	move()
	
	move_and_slide()

func move():
	match state:
		States.WALKING:
			if Input.is_action_just_pressed("jump") or (Time.get_ticks_msec() - jump_buffer) <= buffer_time:
				state = States.JUMP
			elif not is_on_floor():
				state = States.FALLING
			walljump_dir = 0
			
			var direction = Input.get_axis("left", "right")
			
			if direction:
				velocity.x +=  direction * speed * get_process_delta_time()
				if velocity.x > speed_cap:
					velocity.x = speed_cap
				if velocity.x < -speed_cap:
					velocity.x = -speed_cap
			else:
				velocity.x = 0
		States.FALLING:
			if Input.is_action_just_pressed("jump"):
				jump_buffer = Time.get_ticks_msec()
			if is_on_floor():
				state = States.WALKING
			elif is_on_wall() and (Input.is_action_just_pressed("jump") or (Time.get_ticks_msec() - jump_buffer) <= buffer_time):
				state = States.WALLJUMP
			else:
				velocity.y += gravity * get_process_delta_time()
				if velocity.y > fall_velocity_cap:
					velocity.y = fall_velocity_cap
			if is_on_wall():
				walljump_dir = 0
			
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

func rope_detect_rotate():
	var rope_direction = Input.get_vector("left", "right", "up", "down")


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bounce"):
		if Input.is_action_pressed("jump"):
			velocity.y = jump_speed * 1.35
		else:
			velocity.y = jump_speed 
		state = States.FALLING
