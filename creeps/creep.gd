extends Spatial
class_name Creep

var speed = 1
var _waypoints: VertexDACG
var _target: GraphVertex
var life: int

func _ready():
	pass

func _get_new_target(current_target):
	var candidates = current_target.after
	return candidates[randi() % candidates.size()]

func setup(waypoint_graph: VertexDACG):
	_waypoints = waypoint_graph
	var start = waypoint_graph.vertices[randi() % waypoint_graph.vertices.size()]
	translation = start.translation
	_target = start.after[0]
	transform = transform.looking_at(
		_target.translation,
		Vector3(0,1,0)
	)
	_setup()

func hurt(damage: float):
	life -= damage

func _die():
	var self_ind = Manager.creeps.find(self)
	Manager.creeps.remove(self_ind)
	queue_free()

func _setup():
	pass
	
func _process(delta):
	translation -= transform.basis.z * delta * speed
	
	if (translation - _target.translation).length_squared() < 0.1:
		_target = _get_new_target(_target)
		transform = transform.looking_at(
			_target.translation,
			Vector3(0,1,0)
		)
		
	if life <= 0:
		_die()

func is_class(type): return type == "Creep" or .is_class(type)
func    get_class(): return "Creep"
