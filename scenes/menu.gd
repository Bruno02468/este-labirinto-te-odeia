extends Node2D

@onready var titleText = $Title
@onready var diffs = $Dificults

var textUnshuffled : String = "Este Labirinto te Odeia"
var shuffleNow : bool = true


func _ready() -> void:
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	Global.N_Rooms = 4
	Global.N_PortalsPerRoom = 4
	Global.targetTime = 120.0
	
	$Title.text = "[center][shake rate=20.0 level=5 connected=1]%s[/shake][/center]" % textUnshuffled

func shuffle_string(s):
	randomize()
	var a = []
	for c in s: a.append(c)
	a.shuffle()
	return "".join(a)

func _on_timer_timeout() -> void:
	var textInsert = textUnshuffled
	if shuffleNow:
		textInsert = shuffle_string(textUnshuffled)
		shuffleNow = false
	else:
		shuffleNow = true

	$Title.text = "[center][shake rate=20.0 level=5 connected=1]%s[/shake][/center]" % textInsert

func _on_easy_pressed() -> void:
	print("Easy: \n %d Rooms Time: %f",Global.N_Rooms,Global.targetTime)
	Global.N_Rooms = 4
	Global.targetTime = 120.0
	get_node("/root/Main").load_scene("res://scenes/labirint_test.tscn")

func _on_medium_pressed() -> void:
	print("Medium: \n %d Rooms Time: %f",Global.N_Rooms,Global.targetTime)
	Global.N_Rooms = 8
	Global.targetTime = 60.0
	get_node("/root/Main").load_scene("res://scenes/labirint_test.tscn")

func _on_hard_pressed() -> void:
	print("Hard: \n %d Rooms Time: %f",Global.N_Rooms,Global.targetTime)
	Global.N_Rooms = 16
	Global.targetTime = 30.0
	get_node("/root/Main").load_scene("res://scenes/labirint_test.tscn")

func _on_custom_pressed() -> void:
	diffs.visible= false
	Global.N_Rooms = 4
	Global.N_PortalsPerRoom = 4
	Global.targetTime = 120.0
	print("Foi custom")
