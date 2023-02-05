extends Spatial

var all_stage_scenes = [
	preload("res://stages/dummy.tscn")
]

var all_towers = [
	preload("res://towers/dummy.tscn")
]

var all_creeps = [
	preload("res://creeps/capsule.tscn")
]

var current_stage: Stage = null

func _ready():
	randomize()
	current_stage = all_stage_scenes[0].instance()
	current_stage.construct(self)
	add_child(current_stage)
	
	current_stage.gen_waypoint_mesh()
	
	
	for bb in current_stage.build_spots:
		var tower = all_towers[0].instance()
		tower.transform = bb.global_transform
		add_child(tower)
	
	Manager.creeps = []
	for ii in range(10):
		var creep = all_creeps[0].instance()
		creep.setup(current_stage.waypoint_graph)
		Manager.creeps.append(creep)
		add_child(creep)
