extends Node2D


func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().change_scene_to_file("res://MainMenu.tscn")
	if event.is_action_pressed("play_again"):
		get_tree().change_scene_to_file("res://CharacterSelection.tscn")
