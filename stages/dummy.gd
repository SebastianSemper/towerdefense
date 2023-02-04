extends Stage

func get_tiles() -> Spatial:
	if not tiles_ressource:
		tiles_ressource = preload("res://tiles/dummy/dummy.dae").instance()
	return tiles_ressource 

func _ready():
	pass
	
func get_map() -> Array:
#	return [[0.0]]
	return [
		[2.0, 1.3, 2.3],
		[1.0, 0.0, 1.2],
		[2.1, 1.1, 2.2]
	]
