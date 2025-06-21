# File: Matrix.gd
class_name Matrix

extends RefCounted

var rows: int
var cols: int
var data: Array

# Constructor
func _init(_rows: int, _cols: int, default_value = null) -> void:
	rows = _rows
	cols = _cols
	data = []
	for i in range(rows):
		var row = []
		for j in range(cols):
			row.append(default_value)
		data.append(row)

# Get value at (row, col)
func get_cell(row: int, col: int) -> Variant:
	_validate_indices(row, col)
	return data[row][col]

# Set value at (row, col)
func set_cell(row: int, col: int, value: Variant) -> void:
	_validate_indices(row, col)
	data[row][col] = value

# Print matrix (debug)
func print_matrix() -> void:
	var i = 0
	for row in data:
		print(i," ",row)
		i+=1

# Validate indices
func _validate_indices(row: int, col: int) -> void:
	if row < 0 or row >= rows or col < 0 or col >= cols:
		push_error("Matrix index out of bounds: (%d, %d)" % [row, col])
