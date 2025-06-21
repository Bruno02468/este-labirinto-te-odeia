extends Node3D

@export var mat : Material
@export var number : int

@onready var floor_room = $Walls/Floor
@onready var wall_1 = $Walls/NorthWall
@onready var wall_2 = $Walls/SouthWall
@onready var wall_3 = $Walls/EastWall
@onready var wall_4 = $Walls/WestWall
@onready var ceiling_room = $Walls/Ceiling

@onready var floor_text = $RoomText

var N_portal :int = 2

func paintRoom(mater):
	floor_room.material=mater
	wall_1.material=mater
	wall_2.material=mater
	wall_3.material=mater
	wall_4.material=mater
	ceiling_room.material=mater

func _ready() -> void:
	paintRoom(mat)
	floor_text.mesh.text = str(number)
	
func _process(_delta: float) -> void:
	pass
