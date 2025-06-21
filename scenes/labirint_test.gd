extends Node3D

var roomScene : PackedScene = preload("res://scenes/room.tscn")
var PortalScene : PackedScene = preload("res://Portals/Portal.tscn")

var blueMat = preload("res://materials/blue_solid.tres")
var redMat = preload("res://materials/red_solid.tres")

@onready var LoseLabel = $HUD/Lost
@onready var WinLabel = $HUD/Win
@onready var TimerLabel = $HUD/TimerLabel
@onready var FinishTimer = $HUD/FinishTimer

@export var targetTime : float = 10.0
@export var N_Rooms : int = 9
@export var Ncols : int = 3 
@export_range(2, 4, 1) var N_PortalsPerRoom : int = 4

func testMtxConnectivity(Graph:Matrix,size:int):
	#This Function tests if we can reach from the first portal to last
	var con : bool = false
	var i = 0
	while i != size-1:
		for j in range(size):
			if Graph.get_cell(i,j) == 1:
				i = j
				if i == size-1:
					con = true
		i+=1
		if i >= size:
			break
	return con

func genConMtrx(N_Portals:int):
	var numtrys=0
	var conList = Matrix.new(N_Portals, N_Portals, 0)
	print(N_Portals)
	while not(testMtxConnectivity(conList,N_Portals)):
		conList = Matrix.new(N_Portals, N_Portals, 0)
		var idx_list = range(0,N_Portals)
		
		var p = 0
		var i = idx_list[p]
		idx_list.remove_at(p)
		var k = randi_range(1,len(idx_list)-2)
		var j = idx_list[k]
		idx_list.remove_at(k)
		conList.set_cell(i,j,1)
		conList.set_cell(j,i,1)

		while len(idx_list)>0:
			p=randi_range(0,len(idx_list)-1)
			i = idx_list[p]
			idx_list.remove_at(p)
			k=randi_range(0,len(idx_list)-1)
			j = idx_list[k]
			idx_list.remove_at(k)
			conList.set_cell(i,j,1)
			conList.set_cell(j,i,1)
		
		numtrys+=1
	
	print("Genrated in ",numtrys," trys")
	#conList.print_matrix()
	return conList

func checkListConectivity(conList:Array) -> bool:
	var con = false
	var i=0
	for p in range(len(conList)):
		i=conList[i]
		if i == len(conList)-1:
			con = true
			break
	return con

func getConList(N_Portals:int):
	var numtrys=0
	var conList = [0,1,2,3]
	
	while not(checkListConectivity(conList)):
		conList = []
		var idx_list = range(0,N_Portals)
		numtrys+=1
		while len(idx_list)>0:
			var k = randi_range(0,len(idx_list)-1)
			conList.append(idx_list[k])
			idx_list.remove_at(k)
	
	print("Genrated in ",numtrys," trys")
	return conList

func _enter_tree() -> void:
	var N_Portals = N_Rooms * N_PortalsPerRoom - 2*(N_PortalsPerRoom-1)
	
	#### List Approach ####
	var connectionList=getConList(N_Portals)
	print(connectionList)
	
	#### Matrix Approach ####
	var madeEven:bool = false 

	#if N_Portals%2 != 0:
		#N_Portals+=1
		#madeEven = true
	#var connectionList = genConMtrx(N_Portals)
	#connectionList.print_matrix()
	
	for i in range(N_Rooms):
		var room = roomScene.instantiate()
		@warning_ignore("integer_division")
		room.position=Vector3(2*int(i%Ncols)*8,0,2*(i/Ncols)*8)
		room.name = "Room_%d" % i
		room.number=i
		if i == 0:
			room.mat = blueMat
		if i == N_Rooms-1:
			room.mat = redMat
		add_child(room)

	var children = get_children()
	#print(children)
	
	for room in children:
		if room.name.split("_")[0] == "Room":
			var roomNum = int(room.name.split("_")[1])
			var k = N_PortalsPerRoom*(roomNum-1)
			if roomNum == N_Rooms-1:
				var checkPoint=get_node("FinalCheckPoint")
				checkPoint.position=room.position
				var portal = PortalScene.instantiate()
				portal.position=Vector3(2.5,1,0)+room.position
				portal.rotation.y = deg_to_rad(90)
				portal.name = "Portal_%d" % (k+1)
				add_child(portal)
				if madeEven:
					portal = PortalScene.instantiate()
					portal.position=Vector3(-2.5,1,0)+room.position
					portal.rotation.y = deg_to_rad(-90)
					portal.name = "Portal_%d" % (k+2)
					add_child(portal)
			elif roomNum == 0:
				var portal = PortalScene.instantiate()
				portal.position=Vector3(2.5,1,0)+room.position
				portal.rotation.y = deg_to_rad(90)
				portal.name = "Portal_%d" % (k+N_PortalsPerRoom)
				add_child(portal)
			else:
				for i in range(N_PortalsPerRoom):
					var portal = PortalScene.instantiate()
					if i == 0:
						#west
						portal.position=Vector3(0,1,-2.5)+room.position
					if i == 1:
						#east
						portal.position=Vector3(0,1,2.5)+room.position
						portal.rotation.y = deg_to_rad(180)
					if i == 2:
						#north
						portal.position=Vector3(2.5,1,0)+room.position
						portal.rotation.y = deg_to_rad(90)
					if i == 3:
						#south
						portal.position=Vector3(-2.5,1,0)+room.position
						portal.rotation.y = deg_to_rad(-90)
					portal.name = "Portal_%d" % (i+k+1)
					add_child(portal)

	children = get_children()
	#print(children)
	
	#### List Approach ####
	for i in range(N_Portals):
		var j = connectionList[i]
		var portal_i = get_node("Portal_"+str(i))
		var portal_j = get_node("Portal_"+str(j))
		portal_i.other_portal = portal_j

	#### Matrix Approach ####
	#for i in range(N_Portals):
		#for j in range(N_Portals):
			#if connectionList.get_cell(i,j) == 1:
				#var portal_i = get_node("Portal_"+str(i))
				#var portal_j = get_node("Portal_"+str(j))
				#portal_i.other_portal = portal_j
				#portal_j.other_portal = portal_i

func _ready() -> void:
	TimerLabel.time_left = targetTime

func _process(_delta: float) -> void:
	pass

func _on_timmer_label_time_up() -> void:
	get_tree().paused = true
	LoseLabel.visible = true
	FinishTimer.start()
	await FinishTimer.timeout
	get_tree().paused = false

func _on_final_check_point_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		get_tree().paused = true
		WinLabel.visible = true
		FinishTimer.start()
		await FinishTimer.timeout
		get_tree().paused = false
