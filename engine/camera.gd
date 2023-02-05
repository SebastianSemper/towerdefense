extends Camera

export var move_speed: float = 4

var _velocity: Vector3 = Vector3(0,0,0)

func _ready():
	pass
	
func zoom_to(target: Vector3, distance: float):
	pass
	
func zoom_back():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_down"):
		_velocity.z += move_speed
	if Input.is_action_pressed("ui_up"):
		_velocity.z -= move_speed
	if Input.is_action_pressed("ui_left"):
		_velocity.x -= move_speed
	if Input.is_action_pressed("ui_right"):
		_velocity.x += move_speed
		
	translation += delta*_velocity
	
	translation.x = clamp(
		translation.x,
		Manager.stage_extent_x.x,
		Manager.stage_extent_x.y
	)
	translation.z = clamp(
		translation.z,
		Manager.stage_extent_z.x,
		Manager.stage_extent_z.y
	)
	
	_velocity *= exp(-10 * delta)
	if _velocity.length_squared() < 0.5:
		_velocity *= 0
