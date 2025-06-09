extends MeshInstance3D

func draw(a: Vector3, b: Vector3):
	# Begin draw.
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	mesh.surface_add_vertex(a) #Point A
	mesh.surface_add_vertex(b) #Point B
	# End drawing.
	mesh.surface_end()
