extends Control


# The High scores code doesn't really work.... But it's the 
# thought that matters ? I didn't have enough time to fix it.... But it will be 
# a fun project on my break

func _ready():
	$MarginContainer/HBoxContainer/TitleVBox/VBoxContainer/Top1.text = "1. %s" % Global.topScoreString1
	$MarginContainer/HBoxContainer/TitleVBox/VBoxContainer/Top2.text = "2. %s" % Global.topScoreString2
	$MarginContainer/HBoxContainer/TitleVBox/VBoxContainer/Top3.text = "3. %s" % Global.topScoreString3
	$MarginContainer/HBoxContainer/TitleVBox/VBoxContainer/Top4.text = "4. %s" % Global.topScoreString4
	$MarginContainer/HBoxContainer/TitleVBox/VBoxContainer/Top5.text = "5. %s" % Global.topScoreString5

func _on_Exit_pressed():
	$ButtonSound.play()
	get_tree().quit()


func _on_Play_pressed():
	$ButtonSound.play()
	get_tree().change_scene("res://Name/Name.tscn")
