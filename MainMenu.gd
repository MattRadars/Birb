extends Node2D

func _ready():
	var viewport_size = get_viewport_rect().size
	var reference_size = Vector2(1920, 1080)  # Your reference size for scaling
	GameManager.scale_factor = viewport_size / reference_size
	scale = GameManager.scale_factor
	pass
	
func _process(_delta):
	pass
	
func _on_play_btn_pressed():
	$Button_sound.play()
	await get_tree().create_timer(0.17).timeout
	GameManager.player_count += 1
	get_tree().change_scene_to_file("res://Lobby.tscn")
	
func _on_join_btn_pressed():
	$Button_sound.play()
	await get_tree().create_timer(0.17).timeout
	
func _on_quit_btn_pressed():	
	$Button_sound.play()
	await get_tree().create_timer(0.17).timeout
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("back_scene"):
		$HelpAnimation.play("Downwards")
		await get_tree().create_timer(0.9).timeout 
		$HelpScreen.visible = false

func _on_help_btn_pressed():
	$Button_sound.play()
	if $HelpScreen.visible == false:
		$HelpAnimation.play("Upwards")
		$HelpScreen.visible = true
		$HelpScreen.play()
