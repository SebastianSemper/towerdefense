extends Spatial
class_name Damage

onready var shape: CylinderShape

func _ready():
	$Timer.start()
	var co = MeshInstance.new()
	co.mesh = CubeMesh.new()
	add_child(co)
	shape = $area/shape.shape

func _on_Timer_timeout():
	for aa in $area.get_overlapping_areas():
		var parent = aa.get_parent()
		if parent.is_class("Creep"):
			parent.hurt(200)
	queue_free()
	
