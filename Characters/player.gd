extends CharacterBody2D

const MAX_VEL : int = 600
const FLAP : int = -400
var PlayerSelect = 0
var player
var player_id
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var user_id
var timer_left = 3
var count_death : bool = true
var play_dead_position
var explosion
var blinded = true
var phase = true
var shrink = true

signal hit

func _ready():
	
	user_id = multiplayer.get_unique_id()
	$MultiplayerSynchronizer.set_multiplayer_authority(str(player_id).to_int())
	set_rotation(0)
	reset_values.rpc()
	
	

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == user_id:
		if !GameManager.Players[user_id].dead:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			position.x = 400
			velocity.y += gravity * delta
			velocity.x = 0
			
			if velocity.y > MAX_VEL:
				velocity.y = MAX_VEL
		
			if Input.is_action_just_pressed("Jump") and GameManager.Players[user_id].dead == false:
				velocity.y = FLAP
				$FlapFlap.play()
			
			var collision
			move_and_slide()
			if get_slide_collision_count() > 0:
				for i in get_slide_collision_count():
					collision = get_slide_collision(i)
					print(collision.get_collider().name)
			if $Area2D.has_overlapping_areas():
				for i in $Area2D.get_overlapping_areas():
					if i.name == "powerup" and GameManager.Players[user_id].is_powerup == false:
						print(i.powerup)
						update_powerup.rpc("is_powerup", user_id)
						var which_powerup = i.powerup
						update_powerup.rpc(i.powerup, user_id)
						GameManager.Players[user_id].is_powerup = true
						if which_powerup == "Phase":
							GameManager.Players[user_id].phase = true
							return
						if which_powerup == "Blind":
							GameManager.Players[user_id].blind = true
							return
						if which_powerup == "Shrink":
							GameManager.Players[user_id].shrink = true
							return
						
				
			if is_on_ceiling() or is_on_floor() or is_on_wall():
				explosion = true
				$DeathAnimation.play()
				$Boom.play()
				set_player_dead()
				set_rotation(PI/2)
				velocity.y = 0
				await get_tree().create_timer(0.5).timeout
				$DeathAnimation.stop()
				$PlayerSprite.stop()
				explosion = false
					
			

func _process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == user_id:
		if GameManager.Players[user_id].is_powerup:
			$Area2D.monitorable = false
			$Area2D.monitoring = false
			if GameManager.Players[user_id].phase:
				timer_start()
				$ActivePowerup.text = "Phase: " + str(timer_left) + "s"
				if phase:
					$CollisionShape2D.disabled = true
					phase = false
				if timer_left == 0:
					$CollisionShape2D.disabled = false
					update_powerup_end.rpc("is_powerup", user_id)
					GameManager.Players[user_id].is_powerup = false
					$ActivePowerup.text = ""
					update_powerup_end.rpc("Phase", user_id)
					GameManager.Players[user_id].phase = false
					timer_end()
					timer_left = 3
					phase = true
					print('powerup end')
					
			if GameManager.Players[user_id].blind:
				timer_start()
				$ActivePowerup.text = "Blind: " + str(timer_left) + "s"
				if blinded == true:
					blind.rpc(blinded)
					blinded = false
				if timer_left == 0:
					blind.rpc(blinded)
					update_powerup_end.rpc("is_powerup", user_id)
					GameManager.Players[user_id].is_powerup = false
					$ActivePowerup.text = ""
					update_powerup_end.rpc("Blind", user_id)
					GameManager.Players[user_id].blind = false
					timer_end()
					timer_left = 3
					blinded = true
					print('powerup end')
					
			if GameManager.Players[user_id].shrink:
				timer_start()
				$ActivePowerup.text = "Shrink: " + str(timer_left) + "s"
				if shrink:
					scale *= Vector2(0.25, 0.25)
					shrink = false
				if timer_left == 0:
					scale *= Vector2(4,4)
					update_powerup_end.rpc("is_powerup", user_id)
					GameManager.Players[user_id].is_powerup = false
					$ActivePowerup.text = ""
					update_powerup_end.rpc("Shrink", user_id)
					GameManager.Players[user_id].shrink = false
					timer_end()
					timer_left = 3
					shrink = true
					print('powerup end')
				
		else:
			await get_tree().create_timer(5).timeout
			$Area2D.monitorable = true
			$Area2D.monitoring = true

	if GameManager.Players[user_id].dead and !explosion:
		position.x -= 5
		position.y += position.y * delta * 1.5
		

func set_player_dead():
	GameManager.Players[user_id].dead = true
	update_global.rpc(user_id)
	
@rpc("any_peer","call_local")
func update_global(id):
	GameManager.Players[id].dead = true

@rpc("any_peer")
func update_powerup(powerup, id):
	if powerup == "Phase":
		GameManager.Players[id].phase = true
		return
	if powerup == "Blind":
		GameManager.Players[id].blind = true
		return
	if powerup == "Shrink":
		GameManager.Players[id].shrink = true
		return
	if powerup == "is_powerup":
		GameManager.Players[id].is_powerup = true
		return

@rpc("any_peer")
func update_powerup_end(powerup, id):
	if powerup == "Phase":
		GameManager.Players[id].phase = false
		return
	if powerup == "Blind":
		GameManager.Players[id].blind = false
		return
	if powerup == "Shrink":
		GameManager.Players[id].shrink = false
		return
	if powerup == "is_powerup":
		GameManager.Players[id].is_powerup = false
		return

@rpc("any_peer", 'call_local')
func blind(check):
		if check == true and GameManager.Players[user_id].blind == false:
				print('yes')
				get_tree().root.get_node("birb_game/ColorRect").visible = true
				if $MultiplayerSynchronizer.get_multiplayer_authority() == user_id:
					$PlayerSprite.modulate.a = 0.5
		else:
			print('no')
			get_tree().root.get_node("birb_game/ColorRect").visible = false
			if $MultiplayerSynchronizer.get_multiplayer_authority() == user_id:
				$PlayerSprite.modulate.a = 1

@rpc("any_peer", "call_local")
func reset_values():
	GameManager.Players[user_id].phase = false
	GameManager.Players[user_id].shield = false
	GameManager.Players[user_id].shrink = false
	GameManager.Players[user_id].is_powerup = false
	
	
func timer_start():
	if GameManager.Players[user_id].player == 1:
		if $P1Timer.is_stopped():
			$P1Timer.start()
			return
	if GameManager.Players[user_id].player == 2:
		if $P2Timer.is_stopped():
			$P2Timer.start()
			return
	if GameManager.Players[user_id].player == 3:
		if $P3Timer.is_stopped():
			$P3Timer.start()
			return
	if GameManager.Players[user_id].player == 4:
		if $P4Timer.is_stopped():
			$P4Timer.start()
			return

func timer_end():
	if GameManager.Players[user_id].player == 1:
		if !$P1Timer.is_stopped():
			$P1Timer.stop()
			return
	if GameManager.Players[user_id].player == 2:
		if !$P2Timer.is_stopped():
			$P2Timer.stop()
			return
	if GameManager.Players[user_id].player == 3:
		if !$P3Timer.is_stopped():
			$P3Timer.stop()
			return
	if GameManager.Players[user_id].player == 4:
		if !$P4Timer.is_stopped():
			$P4Timer.stop()
			return
	
func _on_p_1_timer_timeout():
	if timer_left > 0:
		timer_left -= 1
	else:
		timer_left = 0

func _on_p_2_timer_timeout():
	if timer_left > 0:
		timer_left -= 1
	else:
		timer_left = 0


func _on_p_3_timer_timeout():
	if timer_left > 0:
		timer_left -= 1
	else:
		timer_left = 0


func _on_p_4_timer_timeout():
	if timer_left > 0:
		timer_left -= 1
	else:
		timer_left = 0
