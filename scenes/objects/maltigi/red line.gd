extends MeshInstance3D

func draw(point_a: Vector3, point_b: Vector3):
	# Begin draw.
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_add_vertex(Vector3(-1, -1, 0)) #Point A
	mesh.surface_add_vertex(Vector3(-1, 1, 0)) #Point B
	# End drawing.
	mesh.surface_end()
