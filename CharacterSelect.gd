extends Node2D

var selectedcharacter = ""
var ready_players = 0
var flag = 0
var player_id
signal start_game

func _ready():
	get_node("PlayerSelect/Name").text = GameManager.playername
	
func _process(delta):
	var start_button = get_node("Select Player")
	var start_effect = get_node("Start Effect")
	start_effect.visible = false
	
	if GameManager.player_count == ready_players:
		start_button.visible = true
		if flag == 0:
			$ButtonAnimation.play("popup")
			flag += 1
	else:
		flag = 0
		$ButtonAnimation.play_backwards("popup")
		start_button.visible = false
		
	match GameManager.PlayerSelect:
		0:
			get_node("PlayerSelect").play("Player0")
			get_node("PlayerSelect/Name").text = "C4"
			selectedcharacter = "C4"
		1:
			get_node("PlayerSelect").play("Player1")
			get_node("PlayerSelect/Name").text = "Bluey"
			selectedcharacter = "Bluey"
		2:
			get_node("PlayerSelect").play("Player2")
			get_node("PlayerSelect/Name").text = "Sunny"
			selectedcharacter = "Sunny"
		3:
			get_node("PlayerSelect").play("Player3")
			get_node("PlayerSelect/Name").text = "Pinky"
			selectedcharacter = "Pinky"


func _on_left_pressed():
	if GameManager.PlayerSelect > 0:
		GameManager.PlayerSelect -= 1

func _on_right_pressed():
	if GameManager.PlayerSelect < 3:
		GameManager.PlayerSelect += 1

func _on_select_player_pressed():
	GameManager.SelectedCharacter = selectedcharacter
	print(GameManager.SelectedCharacter)
	get_tree().change_scene_to_file("res://Lan.tscn")


func _input(event):
	if event.is_action_pressed("back_scene"):
		GameManager.player_count = 0
		get_tree().change_scene_to_file("res://MainMenu.tscn")
		
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		$Frog.play("clicked")
		await get_tree().create_timer(1).timeout
		$Frog.visible = false
	
func _on_button_toggled(button_pressed: bool):
	if button_pressed:
		$PlayersReady.play()
		ready_players += 1
		$Announcement.text = str(str(ready_players) + "/" + str(GameManager.player_count) + " Players are Ready!")
	else:
		$PlayersReady.stop()
		ready_players -= 1
		$Announcement.text = str(str(ready_players) + "/" + str(GameManager.player_count) + " Players are Ready!")

