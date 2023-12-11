extends Area2D

signal hit
signal score

func _on_body_entered(body):
	if body is CharacterBody2D:
		var character = body
		print("Character detected: ", character.user_id)
		print("Character position: ", character.position)

func _ready():
	var prob = randi_range(1,100)
	if prob <= 50:
		$powerup.visible = true
		$powerup/CollisionShape2D.disabled = false
		var powerup_prob = randi_range(1,3)
		match powerup_prob:
			1:
				$powerup.powerup = "phase"
			2:
				$powerup.powerup = "shrink"
			3:
				$powerup.powerup = "flash"
	
		
		
