extends Node
class_name Stage

var debug = false

var TILE_CODES: Array = ["f", "e", "c_o", "c_i", "in", "out"]
var ROT_CODES: Array = [
	Transform.IDENTITY.rotated(Vector3(0,1,0), 0),
	Transform.IDENTITY.rotated(Vector3(0,1,0), PI/2),
	Transform.IDENTITY.rotated(Vector3(0,1,0), PI),
	Transform.IDENTITY.rotated(Vector3(0,1,0), 1.5 * PI),
]

var tiles_ressource = null

var build_spots = []
var waypoint_tiles = []
var waypoint_graph: VertexDACG

var extent_x: Vector2
var extent_z: Vector2

func get_map() -> Array:
	return [[]]
	
func get_tiles() -> Spatial:
	return null

func _ready():
	pass

func get_tile_code(code):
	var element_code = int(round(code))
	return TILE_CODES[element_code]
	
func get_tile_element(tiles: Spatial, code: float):
	return tiles.find_node(get_tile_code(code)).duplicate()
	
func get_tile_rotation(code: float):
	var rotation_code = int(
		round(10 * (code - round(code)))
	)
	return ROT_CODES[rotation_code]

func construct(parent: Node):
	var tiles = self.get_tiles()
	print(tiles.get_children())
	
	var num_u_tiles = 0
	var num_v_tiles = len(self.get_map())
	for tt1 in self.get_map():
		num_u_tiles = max(num_u_tiles, len(tt1))
	
	var tile_size = 6
	var start_x = - 0.5 * float(num_u_tiles - 1) * tile_size
	var pos_x = start_x
	var pos_z = - 0.5 * float(num_v_tiles - 1) * tile_size
	
	Manager.stage_extent_x = Vector2(
		- 0.5 * float(num_u_tiles) * tile_size,
		+ 0.5 * float(num_u_tiles) * tile_size
	)
	Manager.stage_extent_z = Vector2(
		- 0.5 * float(num_v_tiles) * tile_size,
		+ 0.5 * float(num_v_tiles) * tile_size
	)
	
	for tt1 in self.get_map():
		for tt2 in tt1:
			var current_tile = get_tile_element(tiles, tt2)
			var rotation = get_tile_rotation(tt2)
			
			current_tile.transform = rotation
			current_tile.translation.x = pos_x
			current_tile.translation.z = pos_z
			
			var build = current_tile.get_children()[0]
			for bb in build.get_children():
				build_spots.append(bb)
			
			var waypoints = current_tile.get_children()[1]
			waypoint_tiles.append(waypoints)
			
			add_child(current_tile)
			pos_x += tile_size
		pos_x = start_x
		pos_z += tile_size
	
	

func _connect_graph_vertices(vertices: Array):
	for vv1 in vertices:
		for vv2 in vertices:
			if vv1 != vv2:
				if debug:
					var co = MeshInstance.new()
					var cm = CubeMesh.new()
					co.mesh = cm
					co.scale = Vector3(0.1, 0.2, 0.1)
					co.translation = 0.5 * (vv1.translation + vv2.translation)
					add_child(co)
				vv1.before.append(vv2)
				vv2.after.append(vv1)

func gen_waypoint_mesh():
	if not len(waypoint_tiles):
		return
	
	waypoint_graph = VertexDACG.new()
	
	for tile in waypoint_tiles:
		var tile_mesh_tool = MeshDataTool.new()
		tile_mesh_tool.create_from_surface(tile.mesh, 0)
		for vvii in tile_mesh_tool.get_vertex_count():
			var candidate_vertices = []
			for ee in tile_mesh_tool.get_vertex_edges(vvii):
				var edge_middle_pos = 0.5 * (
					tile_mesh_tool.get_vertex(
						tile_mesh_tool.get_edge_vertex(ee, 0)
					)
					+ tile_mesh_tool.get_vertex(
						tile_mesh_tool.get_edge_vertex(ee, 1)
					)
				)
				var global_edge_pos = tile.global_transform.xform(edge_middle_pos)
				var graph_match = waypoint_graph.find_at(global_edge_pos)
				if graph_match == null:
					var new_point = GraphVertex.new()
					new_point.translation = global_edge_pos
					if debug:
						var co = MeshInstance.new()
						var cm = CubeMesh.new()
						co.mesh = cm
						co.scale = Vector3(0.2, 0.4, 0.2)
						co.translation = new_point.translation
						add_child(co)
					waypoint_graph.add_new_vertex(new_point)
					candidate_vertices.append(new_point)
				else:
					candidate_vertices.append(graph_match)
			_connect_graph_vertices(candidate_vertices)
			
	print(waypoint_graph.vertices.size())
	

