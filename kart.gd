extends CharacterBody3D

@export var max_speed: float = 28.0
@export var acceleration: float = 14.0
@export var friction: float = 3.0
@export var turn_speed: float = 2.2

var current_speed: float = 0.0
var steer_input: float = 0.0
var gas_input: float = 0.0

func _physics_process(delta: float) -> void:
	# Fall with gravity if airborne
	if not is_on_floor():
		velocity.y -= 19.6 * delta
	else:
		velocity.y = 0.0

	# Accelerate / Decelerate
	if gas_input != 0.0:
		current_speed = move_toward(current_speed, gas_input * max_speed, acceleration * delta)
	else:
		current_speed = move_toward(current_speed, 0.0, friction * delta)

	# Steer (only turns while moving)
	if abs(current_speed) > 0.5:
		var dir = 1.0 if current_speed > 0 else -1.0
		rotation.y += steer_input * turn_speed * delta * dir

	# Calculate 3D velocity vector
	var forward = -transform.basis.z
	velocity.x = forward.x * current_speed
	velocity.z = forward.z * current_speed

	move_and_slide()

# Functions connected to mobile on-screen touch buttons
func _on_gas_pressed():
	gas_input = 1.0

func _on_gas_released():
	if gas_input > 0:
		gas_input = 0.0

func _on_brake_pressed():
	gas_input = -0.5

func _on_brake_released():
	if gas_input < 0:
		gas_input = 0.0

func _on_left_pressed():
	steer_input = 1.0

func _on_left_released():
	if steer_input > 0:
		steer_input = 0.0

func _on_right_pressed():
	steer_input = -1.0

func _on_right_released():
	if steer_input < 0:
		steer_input = 0.0
