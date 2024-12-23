extends Node

# Resets all the variables in the Global script once a new game has been started
func _ready():
	Global.hreset()

func _process(_delta):
	if $LineEdit.text.empty():
		$Enter.disabled = true
	else:
		$Enter.disabled = false

# Set the player name in the Global script
func _on_Button_pressed():
	Global.PlayerName = $LineEdit.text
	get_tree().change_scene("res://Main/Main.tscn")
