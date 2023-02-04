extends Node
class_name VertexDACG

const MATCHING_TOLERANCE = 0.001

var vertices: Array = []

func _is_unique(vtx: GraphVertex) -> bool:
	for vv in vertices:
		if (vtx.translation - vv.translation).length_squared() < MATCHING_TOLERANCE:
			return false
	return true

func find_at(pos: Vector3) -> GraphVertex:
	for vv in vertices:
		if (pos - vv.translation).length_squared() < MATCHING_TOLERANCE:
			return vv
	return null

func add_new_vertex(vtx: GraphVertex):
	if _is_unique(vtx):
		vertices.append(vtx)
