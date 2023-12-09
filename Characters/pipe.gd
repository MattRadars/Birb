extends Area2D

signal hit
signal score

func _on_body_entered(body):
	if body is CharacterBody2D:
		var character = body
		print("Character detected: ", character.user_id)
		print("Character position: ", character.position)
