extends Node2D

@onready var diffs = $Dificults
@onready var custom = $CustomSelect

@onready var customGo = $CustomSelect/CustomGo
@onready var customRooms = $CustomSelect/Rooms
@onready var customPortals = $CustomSelect/Portals
@onready var customTime = $CustomSelect/Time

var textUnshuffled : String = "ESTE LABIRINTO TE ODEIA"
var shuffleNow : bool = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	custom.visible = false
	diffs.visible = true
	
	Global.N_Rooms = 4
	Global.N_PortalsPerRoom = 4
	Global.targetTime = 120.0
	
	titleScrambler()
	$MainTitle.text = "[center][shake rate=20.0 level=5 connected=1]%s[/shake][/center]" % textUnshuffled

func shuffle_string(s):
	randomize()
	var a = []
	for c in s: a.append(c)
	a.shuffle()
	return "".join(a)

func titleScrambler():
	var children = get_children()
	for title in children:
		if title.name.split("_")[0] == "Title":
			var x = randi_range(-150,1000)
			var y = randi_range(128,500)
			var _theta = randi_range(-180,180)
			#title.rotation(deg_to_rad(theta))
			title.position=Vector2(x,y)
			var textEntry = textUnshuffled
			if randf() > 0.5:
				textEntry = shuffle_string(textUnshuffled)
			title.text = "[center][shake rate=200.0 level=50 connected=1]%s[/shake][/center]" % textEntry
	

func _on_timer_timeout() -> void:
	var textInsert = textUnshuffled
	if shuffleNow:
		textInsert = shuffle_string(textUnshuffled)
		shuffleNow = false
	else:
		shuffleNow = true

	$MainTitle.text = "[center][shake rate=20.0 level=5 connected=1]%s[/shake][/center]" % textInsert
	titleScrambler()
	
func _on_easy_pressed() -> void:
	Global.N_Rooms = 4
	Global.targetTime = 120.0
	print("Easy: \n  ",Global.N_Rooms, " Rooms Time: ",Global.targetTime,"s")
	get_node("/root/Main").load_scene("res://scenes/labirint_test.tscn")

func _on_medium_pressed() -> void:
	Global.N_Rooms = 8
	Global.targetTime = 60.0
	print("Medium: \n  ",Global.N_Rooms, " Rooms Time: ",Global.targetTime,"s")
	get_node("/root/Main").load_scene("res://scenes/labirint_test.tscn")

func _on_hard_pressed() -> void:
	Global.N_Rooms = 16
	Global.targetTime = 30.0
	print("Hard: \n  ",Global.N_Rooms, " Rooms Time: ",Global.targetTime,"s")
	get_node("/root/Main").load_scene("res://scenes/labirint_test.tscn")

func _on_custom_pressed() -> void:
	diffs.visible= false
	custom.visible = true
	
	await customGo.pressed
	
	Global.N_Rooms = customRooms.value
	Global.N_PortalsPerRoom = customPortals.value
	Global.targetTime = customTime.value
	print("Custom: \n  ",Global.N_Rooms, " Rooms ",Global.N_PortalsPerRoom," Portals Time: ",Global.targetTime,"s")
	get_node("/root/Main").load_scene("res://scenes/labirint_test.tscn")
