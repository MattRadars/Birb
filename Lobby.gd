extends Node2D

@export var Address = IP.get_local_addresses()[4]
@export var port = 35
var peer
var character_select
var game_start

func _ready():
	$EnterUsername.max_length = 8
	GameManager.ip = Address
	var viewport_size = get_viewport_rect().size
	var reference_size = Vector2(1920, 1080)  # Your reference size for scaling
	GameManager.scale_factor = viewport_size / reference_size
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	scale = GameManager.scale_factor
	pass
	
func _input(event):
	if event.is_action_pressed("back_scene"):
		get_tree().change_scene_to_file("res://MainMenu.tscn")

func _process(_delta):
	if !GameManager.Players.has(multiplayer.get_unique_id()):
		$StartBTN_temp.disabled = true
		$StartBTN_temp.visible = false
	else:
		$StartBTN_temp.disabled = false
		$StartBTN_temp.visible = true
	
#	if GameManager.no_host == true:
#		$IP.visible = false
#		$Border2.visible = false
#		$JoinBTN.visible = false
#		$Border.position = Vector2(959,417)
#		$EnterUsername.position = Vector2(660,360)
#		GameManager.no_host = false
#	pass

func _on_host_btn_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error != OK:
		$Warning.text = "Server Already Exists!"
		print("Hosting failed! Error: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	var seed = randi_range(1, 69420)
	GameManager.randomized = seed
	multiplayer.set_multiplayer_peer(peer)
	CharacterSelect()
	SendPlayerInformation($EnterUsername.text, multiplayer.get_unique_id())
	$Button_sound.play()
	await get_tree().create_timer(0.17).timeout

func _on_join_btn_pressed():
	if $IP.text == Address:
		peer = ENetMultiplayerPeer.new()
		peer.create_client($IP.text, port)
		peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
		multiplayer.set_multiplayer_peer(peer)
		$HostBTN.visible = false
		$HostBTN.disabled = true
		$Button_sound.play()
		await get_tree().create_timer(0.17).timeout
	else:
		$Warning.text = "Wrong Host Address!"
		
@rpc('any_peer')
func SendPlayerInformation(player_name, id):
	var player = 1

	if !GameManager.Players.has(id):
		for i in GameManager.Players:
			if GameManager.Players[i].player == player:
				player += 1
		GameManager.Players[id] = {
			"name": player_name,
			"id": id,
			"character": "C4",
			"selected": 0,
			"player": player,
			"ready": false,
			"dead": false,
			"phase": false,
			"blind": false,
			"shrink": false,
			"is_powerup": false,
			"winner": false
		}
	update_seed.rpc(GameManager.randomized)
		
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)
			


func CharacterSelect():
	character_select = load('res://CharacterSelection.tscn').instantiate()
	get_tree().root.add_child(character_select)
	self.hide()
	

func peer_connected(id):
	print("Player Connected " + str(id))

	
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()

func connected_to_server():
	print("Connected to server!")
	SendPlayerInformation.rpc_id(1, $EnterUsername.text, multiplayer.get_unique_id())
	
func connection_failed():
	print("Connection failed!")

func _on_start_btn_temp_pressed():
	$Button_sound.play()
	await get_tree().create_timer(0.17).timeout
	CharacterSelect()
	
@rpc("any_peer", "call_local")
func update_seed(value):
	GameManager.randomized = value
