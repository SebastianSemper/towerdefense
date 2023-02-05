extends Spatial
class_name Tower

onready var view: Area
onready var collide: CollisionShape
onready var tower: Spatial
onready var canon: Spatial

export var fire_rate: float
var _time_since_last_shot: float
var _is_firing: bool = false

var _active_target: Area = null
var _reachable_targets: Array

var damage_ressource = preload("res://towers/damage.tscn")

func _ready():
	view = $view
	collide = $view/collide
	tower = $mesh/base/head
	canon = $mesh/base/head/canon_mount/canon
	view.connect("area_entered", self, "_something_in_range")
	view.connect("area_exited", self, "_something_outof_range")

func _process(delta):
	if _active_target == null:
		return
	
	var tower_trafo:Transform = tower.transform.looking_at(
		tower.global_transform.xform_inv(_active_target.global_transform.origin),
		Vector3(0, 1, 0)
	)
	var angles_target1 = tower_trafo.basis.get_euler()
	
	tower.transform = tower.transform.rotated(
		Vector3(0,1,0),
		angles_target1.y + PI
	)
	
	var canon_trafo:Transform = canon.transform.looking_at(
		canon.global_transform.xform_inv(_active_target.global_transform.origin),
		Vector3(0, 1, 0)
	)
	var angles_target2 = canon_trafo.basis.get_euler()
	canon.transform = canon.transform.rotated(
		Vector3(-1,0,0),
		angles_target2.x
	)

	if _is_firing:
		_time_since_last_shot += delta
		if _time_since_last_shot > 1.0 / fire_rate:
			_fire_shot()
			_time_since_last_shot = 0
			
func _fire_shot():
	var damage = damage_ressource.instance()
	
	damage.translate(transform.xform_inv(_active_target.global_transform.origin))
		
func _start_fire():
	_time_since_last_shot = 2.0 / fire_rate
	_is_firing = true
	
func _stop_fire():
	_is_firing = false

func _something_in_range(area: Area):
	if not area.get_parent().is_class("Creep"):
		return 
		
	if not _reachable_targets.has(area):
		_reachable_targets.append(area)
	
	if not _active_target:
		_active_target = _reachable_targets[-1]
		_start_fire()
	
func _something_outof_range(area: Area):
	if not area.get_parent().is_class("Creep"):
		return
	_reachable_targets.remove(_reachable_targets.find(area))
	
	if area == _active_target:
		if _reachable_targets.size():
			_active_target = _reachable_targets[0]
		else:
			_active_target = null
			_stop_fire()

