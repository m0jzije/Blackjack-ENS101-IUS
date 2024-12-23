extends Node2D

func _ready():
	$LSound.play()

func _on_Button_pressed():
	$ButtonSound.play()
	get_tree().quit()
