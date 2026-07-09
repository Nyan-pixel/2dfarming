class_name TileMapLayerDataResource
extends NodeDataResource

@export var tiles := []

func _save_data(node: Node2D) -> void:
	super._save_data(node)

	var layer := node as TileMapLayer
	tiles.clear()

	for cell in layer.get_used_cells():
		tiles.append({
			"pos": cell,
			"source": layer.get_cell_source_id(cell),
			"atlas": layer.get_cell_atlas_coords(cell),
			"alt": layer.get_cell_alternative_tile(cell)
		})
func _load_data(window: Window) -> void:
	var layer := window.get_node(node_path) as TileMapLayer

	layer.clear()

	for tile in tiles:
		layer.set_cell(
			tile["pos"],
			tile["source"],
			tile["atlas"],
			tile["alt"]
		)
