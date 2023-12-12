extends Area2D

var powerup = ''


func _on_area_entered(area):
	queue_free()
