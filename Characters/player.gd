extends CharacterBody2D

const MAX_VEL : int = 600
const FLAP : int = -400
var flying : bool = false
var falling : bool = false
var PlayerSelect = 0
var player
var player_id
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var user_id
var timer_left = 5
var count_death : bool = true

signal hit

func _ready():
	
	user_id = multiplayer.get_unique_id()
	$MultiplayerSynchronizer.set_multiplayer_authority(str(player_id).to_int())
	set_rotation(0)
	

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
					
						
				
			if is_on_ceiling() or is_on_floor() or is_on_wall():
				if !GameManager.Players[user_id].shield and (collision and collision.get_collider().name != 'powerup'):
					$DeathAnimation.play()
					$Boom.play()
					set_player_dead()
					set_rotation(PI/2)
					$DeathAnimation.stop()
					$PlayerSprite.stop()
					
				else:
					await get_tree().create_timer(0.9).timeout
					update_powerup.rpc("Shield", user_id)
					
			

func _process(delta):
	if GameManager.Players[user_id].is_powerup:
		if GameManager.Players[user_id].phase == true:
			$PhaseTimer.start()
			GameManager.Players[user_id].phase = false
			update_powerup.rpc("Phase", user_id)
		update_powerup.rpc("Phase", user_id)
		$ActivePowerup.text = "Phase: " + str(timer_left) + "s"
		$CollisionShape2D.disabled = true
		if timer_left == 0:
			$CollisionShape2D.disabled = false
			GameManager.Players[user_id].is_powerup = false
			update_powerup.rpc("is_powerup", user_id)
			$PhaseTimer.stop()
			$ActivePowerup.text = ""
			
	
	if GameManager.Players[user_id].dead:
		position.x -= 5
		position.y += position.y * delta * 1.5
		

func set_player_dead():
	GameManager.Players[user_id].dead = true
	update_global.rpc(user_id)
	
@rpc("any_peer","call_local")
func update_global(id):
	GameManager.Players[id].dead = true

@rpc("any_peer","call_local")
func update_powerup(powerup, id):
	if powerup == "Phase":
		GameManager.Players[id].phase = false
	if powerup == "Shield":
		GameManager.Players[id].shield = false
	if powerup == "Shrink":
		GameManager.Players[id].shrink = false
	if powerup == "is_powerup":
		GameManager.Players[id].is_powerup = false

func _on_phase_timer_timeout():
	timer_left -= 1
	pass # Replace with function body.
