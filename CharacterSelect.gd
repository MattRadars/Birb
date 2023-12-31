extends Node2D

var flag
var player_id
var selectedcharacter = ""
signal start_game

func _ready():
	player_id = multiplayer.get_unique_id()
	$MultiplayerSynchronizer.set_multiplayer_authority(str(player_id).to_int())
	update_global_value.rpc("player_count", len(GameManager.Players))
	update_global_value.rpc("ready_text", 0)
	scale = GameManager.scale_factor
	flag = false
	$IP.text = "IP: " + str(GameManager.ip)
	
	
func _process(_delta):
	if GameManager.player_count == 0:
		$Announcement.text = "No friends? T-T"
		$Start.visible = false
	else:
		$Announcement.text = GameManager.ready_text
		$Start.visible = true
	for i in GameManager.Players:
		if GameManager.Players[i].player == 1:
			$"P1Border/Player Name".text = GameManager.Players[i].name
		if GameManager.Players[i].player == 2:
			$"P2Border/Player Name".text = GameManager.Players[i].name
		if GameManager.Players[i].player == 3:
			$"P3Border/Player Name".text = GameManager.Players[i].name
		if GameManager.Players[i].player == 4:
			$"P4Border/Player Name".text = GameManager.Players[i].name
	
	if $MultiplayerSynchronizer.get_multiplayer_authority() == player_id:
		if GameManager.Players.has(player_id):
			$P2Border/Left.visible = true
			$P2Border/Right.visible = true
			$"P2Border/Player Name".visible = true
			$P2Border/PlayerSelect.visible = true
			$P2Border/ConfirmBTN.visible = true
			$P3Border/Left.visible = true
			$P3Border/Right.visible = true
			$"P3Border/Player Name".visible = true
			$P3Border/PlayerSelect.visible = true
			$P3Border/ConfirmBTN.visible = true
			$P4Border/Left.visible = true
			$P4Border/Right.visible = true
			$"P4Border/Player Name".visible = true
			$P4Border/PlayerSelect.visible = true
			$P4Border/ConfirmBTN.visible = true
			
			for i in GameManager.Players:
				var id = GameManager.Players[i].player
				var styling = StyleBoxTexture.new()
				match id:
					1:
						if GameManager.Players[i].ready == true:
							styling.texture = load("res://Buttons/check.png")
							$P1Border/ConfirmBTN.add_theme_stylebox_override('disabled', styling)
						else:
							styling.texture = load("res://Buttons/x.png")
							$P1Border/ConfirmBTN.add_theme_stylebox_override('disabled', styling)
					2:
						if GameManager.Players[i].ready == true:
							styling.texture = load("res://Buttons/check.png")
							$P2Border/ConfirmBTN.add_theme_stylebox_override('disabled', styling)
						else:
							styling.texture = load("res://Buttons/x.png")
							$P2Border/ConfirmBTN.add_theme_stylebox_override('disabled', styling)
					3:
						if GameManager.Players[i].ready == true:
							styling.texture = load("res://Buttons/check.png")
							$P3Border/ConfirmBTN.add_theme_stylebox_override('disabled', styling)
						else:
							styling.texture = load("res://Buttons/x.png")
							$P3Border/ConfirmBTN.add_theme_stylebox_override('disabled', styling)
					4:
						if GameManager.Players[i].ready == true:
							styling.texture = load("res://Buttons/check.png")
							$P4Border/ConfirmBTN.add_theme_stylebox_override('disabled', styling)
						else:
							styling.texture = load("res://Buttons/x.png")
							$P4Border/ConfirmBTN.add_theme_stylebox_override('disabled', styling)
			
			if GameManager.Players[player_id].player == 1:
				if GameManager.ready_to_start:
					$Start.disabled = false
				else:
					$Start.disabled = true
				#$P1Border/ConfirmBTN.set_pressed_no_signal(GameManager.Players[player_id].ready)
				$P1Border/PlayerSelect.visible = true
				$P2Border/Left.disabled = true
				$P2Border/Right.disabled = true
				$P3Border/Left.disabled = true
				$P3Border/Right.disabled = true
				$P4Border/Left.disabled = true
				$P4Border/Right.disabled = true
				$P2Border/Left.visible = false
				$P2Border/Right.visible = false
				$P3Border/Left.visible = false
				$P3Border/Right.visible = false
				$P4Border/Left.visible = false
				$P4Border/Right.visible = false
				
				if GameManager.player_count < 2:
					$P2Border/Left.visible = false
					$P2Border/Right.visible = false
					$"P2Border/Player Name".visible = false
					$P2Border/PlayerSelect.visible = false
					$P2Border/ConfirmBTN.visible = false
				if GameManager.player_count < 3:
					$P3Border/Left.visible = false
					$P3Border/Right.visible = false
					$"P3Border/Player Name".visible = false
					$P3Border/PlayerSelect.visible = false
					$P3Border/ConfirmBTN.visible = false
				if GameManager.player_count < 4:
					$P4Border/Left.visible = false
					$P4Border/Right.visible = false
					$"P4Border/Player Name".visible = false
					$P4Border/PlayerSelect.visible = false
					$P4Border/ConfirmBTN.visible = false
				$P2Border/ConfirmBTN.disabled = true
				$P3Border/ConfirmBTN.disabled = true
				$P4Border/ConfirmBTN.disabled = true
				
			if GameManager.Players[player_id].player == 2:
				#$P2Border/ConfirmBTN.set_pressed_no_signal(GameManager.Players[player_id].ready)
				$P2Border/PlayerSelect.visible = true
				$P1Border/Left.disabled = true
				$P1Border/Right.disabled = true
				$P3Border/Left.disabled = true
				$P3Border/Right.disabled = true
				$P4Border/Left.disabled = true
				$P4Border/Right.disabled = true
				$P1Border/Left.visible = false
				$P1Border/Right.visible = false
				$P3Border/Left.visible = false
				$P3Border/Right.visible = false
				$P4Border/Left.visible = false
				$P4Border/Right.visible = false
				$P1Border/ConfirmBTN.disabled = true
				$P3Border/ConfirmBTN.disabled = true
				$P4Border/ConfirmBTN.disabled = true
				$Start.disabled = true
				$Start.visible = false
				
				if GameManager.player_count < 3:
					$P3Border/Left.visible = false
					$P3Border/Right.visible = false
					$"P3Border/Player Name".visible = false
					$P3Border/PlayerSelect.visible = false
					$P3Border/ConfirmBTN.visible = false
				if GameManager.player_count < 4:
					$P4Border/Left.visible = false
					$P4Border/Right.visible = false
					$"P4Border/Player Name".visible = false
					$P4Border/PlayerSelect.visible = false
					$P4Border/ConfirmBTN.visible = false
				
				
			if GameManager.Players[player_id].player == 3:
				$P3Border/PlayerSelect.visible = true
				$P1Border/Left.disabled = true
				$P1Border/Right.disabled = true
				$P2Border/Left.disabled = true
				$P2Border/Right.disabled = true
				$P4Border/Left.disabled = true
				$P4Border/Right.disabled = true
				$P1Border/Left.visible = false
				$P1Border/Right.visible = false
				$P2Border/Left.visible = false
				$P2Border/Right.visible = false
				$P4Border/Left.visible = false
				$P4Border/Right.visible = false
				$P1Border/ConfirmBTN.disabled = true
				$P2Border/ConfirmBTN.disabled = true
				$P4Border/ConfirmBTN.disabled = true
				$Start.disabled = true
				$Start.visible = false
				
				if GameManager.player_count == 3:
					$P4Border/Left.visible = false
					$P4Border/Right.visible = false
					$"P4Border/Player Name".visible = false
					$P4Border/PlayerSelect.visible = false
					$P4Border/ConfirmBTN.visible = false
				
			if GameManager.Players[player_id].player == 4:
				$P4Border/PlayerSelect.visible = true
				$P1Border/Left.disabled = true
				$P1Border/Right.disabled = true
				$P2Border/Left.disabled = true
				$P2Border/Right.disabled = true
				$P3Border/Left.disabled = true
				$P3Border/Right.disabled = true
				$P1Border/Left.visible = false
				$P1Border/Right.visible = false
				$P2Border/Left.visible = false
				$P2Border/Right.visible = false
				$P3Border/Left.visible = false
				$P3Border/Right.visible = false
				$P1Border/ConfirmBTN.disabled = true
				$P2Border/ConfirmBTN.disabled = true
				$P3Border/ConfirmBTN.disabled = true
				$Start.disabled = true
				$Start.visible = false
				
		for i in GameManager.Players:
			if GameManager.Players[i].player == 1:
				#$P1Border/ConfirmBTN.button_pressed = GameManager.Players[i].ready
				$P1Border/ConfirmBTN.set_pressed_no_signal(GameManager.Players[i].ready)
				match GameManager.Players[i].selected:
						0:
							$P1Border/PlayerSelect.play("Player0")
							$P1Border/PlayerSelect/Name.text = "C4"
							selectedcharacter = "C4"
						1:
							$P1Border/PlayerSelect.play("Player1")
							$P1Border/PlayerSelect/Name.text = "Bluey"
							selectedcharacter = "Bluey"
						2:
							$P1Border/PlayerSelect.play("Player2")
							$P1Border/PlayerSelect/Name.text = "Sunny"
							selectedcharacter = "Sunny"
						3:
							$P1Border/PlayerSelect.play("Player3")
							$P1Border/PlayerSelect/Name.text = "Pinky"
							selectedcharacter = "Pinky"
						4:
							$P1Border/PlayerSelect.play("Player4")
							$P1Border/PlayerSelect/Name.text = "Peace"
							selectedcharacter = "Peace"
							
			if GameManager.Players[i].player == 2:
				$P2Border/ConfirmBTN.set_pressed_no_signal(GameManager.Players[i].ready)
				match GameManager.Players[i].selected:
						0:
							$P2Border/PlayerSelect.play("Player0")
							$P2Border/PlayerSelect/Name.text = "C4"
							selectedcharacter = "C4"
						1:
							$P2Border/PlayerSelect.play("Player1")
							$P2Border/PlayerSelect/Name.text = "Bluey"
							selectedcharacter = "Bluey"
						2:
							$P2Border/PlayerSelect.play("Player2")
							$P2Border/PlayerSelect/Name.text = "Sunny"
							selectedcharacter = "Sunny"
						3:
							$P2Border/PlayerSelect.play("Player3")
							$P2Border/PlayerSelect/Name.text = "Pinky"
							selectedcharacter = "Pinky"
						4:
							$P2Border/PlayerSelect.play("Player4")
							$P2Border/PlayerSelect/Name.text = "Peace"
							selectedcharacter = "Peace"
			
			if GameManager.Players[i].player == 3:
				$P3Border/ConfirmBTN.set_pressed_no_signal(GameManager.Players[i].ready)
				match GameManager.Players[i].selected:
						0:
							$P3Border/PlayerSelect.play("Player0")
							$P3Border/PlayerSelect/Name.text = "C4"
							selectedcharacter = "C4"
						1:
							$P3Border/PlayerSelect.play("Player1")
							$P3Border/PlayerSelect/Name.text = "Bluey"
							selectedcharacter = "Bluey"
						2:
							$P3Border/PlayerSelect.play("Player2")
							$P3Border/PlayerSelect/Name.text = "Sunny"
							selectedcharacter = "Sunny"
						3:
							$P3Border/PlayerSelect.play("Player3")
							$P3Border/PlayerSelect/Name.text = "Pinky"
							selectedcharacter = "Pinky"
						4:
							$P3Border/PlayerSelect.play("Player4")
							$P3Border/PlayerSelect/Name.text = "Peace"
							selectedcharacter = "Peace"
			
			if GameManager.Players[i].player == 4:
				$P4Border/ConfirmBTN.set_pressed_no_signal(GameManager.Players[i].ready)
				match GameManager.Players[i].selected:
						0:
							$P4Border/PlayerSelect.play("Player0")
							$P4Border/PlayerSelect/Name.text = "C4"
							selectedcharacter = "C4"
						1:
							$P4Border/PlayerSelect.play("Player1")
							$P4Border/PlayerSelect/Name.text = "Bluey"
							selectedcharacter = "Bluey"
						2:
							$P4Border/PlayerSelect.play("Player2")
							$P4Border/PlayerSelect/Name.text = "Sunny"
							selectedcharacter = "Sunny"
						3:
							$P4Border/PlayerSelect.play("Player3")
							$P4Border/PlayerSelect/Name.text = "Pinky"
							selectedcharacter = "Pinky"
						4:
							$P4Border/PlayerSelect.play("Player4")
							$P4Border/PlayerSelect/Name.text = "Peace"
							selectedcharacter = "Peace"

func _on_left_pressed():
	if $MultiplayerSynchronizer.get_multiplayer_authority() == player_id:
		if GameManager.Players[player_id].selected >= 0:
			GameManager.Players[player_id].selected -= 1
		if GameManager.Players[player_id].selected == -1:
			GameManager.Players[player_id].selected = 4
		match GameManager.Players[player_id].selected:
			0:
				GameManager.Players[player_id].character = "C4"
			1:
				GameManager.Players[player_id].character = "Bluey"
			2:
				GameManager.Players[player_id].character = "Sunny"
			3:
				GameManager.Players[player_id].character = "Pinky"
			4:
				GameManager.Players[player_id].character = "Peace"
		update_global_value.rpc("character", [GameManager.Players[player_id].selected, 
		GameManager.Players[player_id].character, player_id])

func _on_right_pressed():
	if $MultiplayerSynchronizer.get_multiplayer_authority() == player_id:
		if GameManager.Players[player_id].selected <= 4:
			GameManager.Players[player_id].selected += 1
		if GameManager.Players[player_id].selected == 5:
			GameManager.Players[player_id].selected = 0
		match GameManager.Players[player_id].selected:
			0:
				GameManager.Players[player_id].character = "C4"
			1:
				GameManager.Players[player_id].character = "Bluey"
			2:
				GameManager.Players[player_id].character = "Sunny"
			3:
				GameManager.Players[player_id].character = "Pinky"
			4:
				GameManager.Players[player_id].character = "Peace"
		update_global_value.rpc("character", [GameManager.Players[player_id].selected, 
		GameManager.Players[player_id].character, player_id])

func _on_select_player_pressed():
	GameManager.SelectedCharacter = selectedcharacter
	print(GameManager.SelectedCharacter)
	game_start.rpc()
	
@rpc("any_peer", "call_local")
func game_start():
	get_tree().change_scene_to_file("res://birb_game.tscn")
	$CharacterSelectMusic.stop()
	self.hide()

func _input(event):
	if event.is_action_pressed("back_scene"):
		GameManager.player_count = 0
		get_tree().change_scene_to_file("res://MainMenu.tscn")
		
	if event is InputEventKey and event.is_pressed() and event.as_text_keycode() == "F":
		$Frog.play("clicked")
		await get_tree().create_timer(1).timeout
		$Frog.visible = false

@rpc("any_peer")
func _on_button_toggled(button_pressed: bool):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == player_id:
		if button_pressed:
			update_global_value.rpc("ready_status", ["ready", player_id])
		else:
			$PlayersReady.stop()
			update_global_value.rpc("ready_status", ["unready", player_id])
	var ready_count = 0
	for i in GameManager.Players:
		if GameManager.Players[i].ready == true:
			ready_count += 1
	
	update_global_value.rpc("ready_text", ready_count)
	
	$Announcement.text = GameManager.ready_text
	if ready_count == GameManager.player_count:
		$PlayersReady.play()
		GameManager.ready_to_start = true
		update_global_value.rpc("ready_to_start", true)
	else:
		$PlayersReady.stop()
		GameManager.ready_to_start = false
		update_global_value.rpc("ready_to_start", false)

@rpc("any_peer", "call_local")
func update_global_value(type, data):
	if type == "character":
		GameManager.Players[data[2]].selected = data[0]
		GameManager.Players[data[2]].character = data[1]
	if type == "ready_status":
		if data[0] == "ready":
			GameManager.Players[data[1]].ready = true
		if data[0] == "unready":
			GameManager.Players[data[1]].ready = false
	if type == "player_count":	
		GameManager.player_count = data
	if type == "ready_text":
		GameManager.ready_text = str(str(data) + "/" + str(GameManager.player_count) + " players are ready!")
	if type == "ready_to_start":
		GameManager.ready_to_start = data
			

	
