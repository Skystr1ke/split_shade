extends CharacterBody2D


const SPEED = 215.0
const JUMP_VELOCITY = 330.0
const JUMP_DIVISOR = 2.5
const GRAVITY = 1480.0
const GRAVITY_MULTIPLIER = 1.2

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		var gravity: float = GRAVITY * -up_direction.y * delta
		if velocity.y * up_direction.y < 0.0:
			gravity *= GRAVITY_MULTIPLIER
		velocity.y += gravity

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * up_direction.y
	if Input.is_action_just_released("jump") and velocity.y * up_direction.y > 0.0:
		velocity.y /= JUMP_DIVISOR
	
	var direction: float = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	move_and_slide()
