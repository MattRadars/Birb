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
		var powerup_prob = randi_range(1,4)
		match powerup_prob:
			1:
				$powerup.powerup = "Phase"
				$powerup/Sprite2D.texture = load("res://powerups/invisibility-powerup4.png")
			2:
				$powerup.powerup = "Shrink"
				$powerup/Sprite2D.texture = load("res://powerups/size-powerup3.png")
			3:
				$powerup.powerup = "Blind"
				$powerup/Sprite2D.texture = load("res://powerups/blind-power-up.png")
	
		
		
