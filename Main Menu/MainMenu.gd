extends Control

# Change scene to "Name" when the start button is pressed
func _on_start_pressed():
	$BSound.play()
	get_tree().change_scene("res://Name/Name.tscn")

# Quit the game when the quit button is pressed
func _on_quit_pressed():
	$BSound.play()
	get_tree().quit()


func _on_High_Scores_pressed():
	$BSound.play()
	get_tree().change_scene("res://Main Menu/High Scores.tscn")

