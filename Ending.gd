extends Node2D

func _ready():
	scale = GameManager.scale_factor
	$Name.text = GameManager.winner[0]
	$Score.text = "Score: " + str(GameManager.score)
	match GameManager.winner[1]:
		"C4":
			$Winner.play("Player0")
		"Bluey":
			$Winner.play("Player1")
		"Sunny":
			$Winner.play("Player2")
		"Pinky":
			$Winner.play("Player3")
		"Peace":
			$Winner.play("Player4")
	
	for i in GameManager.Players:
		update_status.rpc(i)

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().change_scene_to_file("res://MainMenu.tscn")
	if event.is_action_pressed("play_again"):
		get_tree().change_scene_to_file("res://CharacterSelection.tscn")
		
		
@rpc("any_peer", "call_local")
func update_status(id):
	GameManager.Players[id].dead = false
	GameManager.Players[id].ready = false

