extends Node2D

var selectedcharacter = ""
var player_id
signal start_game

func _ready():
	player_id = multiplayer.get_unique_id()
	$MultiplayerSynchronizer.set_multiplayer_authority(str(player_id).to_int())
	
func _process(_delta):
	if GameManager.Players:
		$Label.text = str(player_id)
	if $MultiplayerSynchronizer.get_multiplayer_authority() == player_id:
		if GameManager.Players.has(player_id):
			if GameManager.Players[player_id].player == 1:
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
				
			if GameManager.Players[player_id].player == 2:
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
				$Select.disabled = true
				$Select.visible = false
				
				
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
				$Select.disabled = true
				$Select.visible = false
				
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
				$Select.disabled = true
				$Select.visible = false
				
		for i in GameManager.Players:
			if GameManager.Players[i].player == 1:
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
			if GameManager.Players[i].player == 2:
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
			
			if GameManager.Players[i].player == 3:
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
			
			if GameManager.Players[i].player == 4:
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
	
func _on_left_pressed():
	if $MultiplayerSynchronizer.get_multiplayer_authority() == player_id:
		if GameManager.Players[player_id].selected >= 0:
			GameManager.Players[player_id].selected -= 1
		if GameManager.Players[player_id].selected == -1:
			GameManager.Players[player_id].selected = 3
		match GameManager.Players[player_id].selected:
			0:
				GameManager.Players[player_id].character = "C4"
			1:
				GameManager.Players[player_id].character = "Bluey"
			2:
				GameManager.Players[player_id].character = "Sunny"
			3:
				GameManager.Players[player_id].character = "Pinky"
		update_global_value.rpc(GameManager.Players[player_id].selected, 
		GameManager.Players[player_id].character, player_id)

func _on_right_pressed():
	if $MultiplayerSynchronizer.get_multiplayer_authority() == player_id:
		if GameManager.Players[player_id].selected <= 3:
			GameManager.Players[player_id].selected += 1
		if GameManager.Players[player_id].selected == 4:
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
		update_global_value.rpc(GameManager.Players[player_id].selected, 
		GameManager.Players[player_id].character, player_id)
	
@rpc("any_peer", "call_local")
func update_global_value(select, chara, id):
	GameManager.Players[id].selected = select
	GameManager.Players[id].character = chara

@rpc('any_peer', 'call_local')
func StartGame():
	var game_start = load('res://birb_game.tscn').instantiate()
	get_tree().root.add_child(game_start)
	game_start.scale = GameManager.scale_factor
	self.hide()
	
func _on_select_player_pressed():
	var num = randi_range(1, 42069)
	GameManager.randomized = num
	update_random.rpc(num)
	StartGame.rpc()

@rpc("any_peer", "call_local")
func update_random(value):
	GameManager.randomized = value

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://MainMenu.tscn")


 
