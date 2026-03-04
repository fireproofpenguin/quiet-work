class_name PlayerController extends CharacterBody3D

@export_category("References")
@export var camera: CameraController
@export var state_chart: StateChart
@export var standing_collision: CollisionShape3D
@export var crouching_collision: CollisionShape3D
@export var crouch_check: ShapeCast3D
@export_category("Movement Settings")
@export_group("Easing")
@export var acceleration: float = 0.2
@export var deceleration: float = 0.5
@export_group("Speed")
@export var default_speed: float = 7.0
@export var sprint_speed: float = 3.0
@export var crouch_speed: float = -5.0
@export_group("Jump Settings")
@export var jump_velocity: float = 5.0

var current_state: PlayerState

var _input_dir: Vector2 = Vector2.ZERO
var _movement_velocity: Vector3 = Vector3.ZERO
var sprint_modifier: float = 0.0
var crouch_modifier: float = 0.0
var speed: float = 0.0

func _unhandled_key_input(event):
	if event.is_action("debug_quit"):
		get_tree().quit()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var speed_modifier = sprint_modifier + crouch_modifier
	speed = default_speed + speed_modifier

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	_input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var current_velocity = Vector2(_movement_velocity.x, _movement_velocity.z)
	var direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * speed, acceleration)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration)
	
	_movement_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y)
	
	velocity = _movement_velocity
	
	move_and_slide()

func update_rotation(rotation_input: Vector3) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)

func sprint() -> void:
	sprint_modifier = sprint_speed
	
func walk() -> void:
	sprint_modifier = 0.0
	
func stand() -> void:
	crouch_modifier = 0.0
	standing_collision.disabled = false
	crouching_collision.disabled = true
	
func crouch() -> void:
	crouch_modifier = crouch_speed
	standing_collision.disabled = true
	crouching_collision.disabled = false
	
func jump() -> void:
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	velocity.y += jump_velocity
