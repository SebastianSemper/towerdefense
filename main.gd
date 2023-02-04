extends Spatial

var all_stage_scenes = [
	preload("res://stages/dummy.tscn")
]

var all_towers = [
	preload("res://towers/dummy.tscn")
]

var current_stage: Stage = null

func _ready():
	current_stage = all_stage_scenes[0].instance()
	current_stage.construct(self)
	add_child(current_stage)
	
	current_stage.gen_waypoint_mesh()
	
	for bb in current_stage.build_spots:
		var tower = all_towers[0].instance()
		tower.transform = bb.global_transform
		add_child(tower)
