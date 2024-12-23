extends Node2D
class_name Main

# Initializing needed variables
var Card = preload('res://Main/Card.tscn')

var cNumb := ["2", "3", "4", "5", "6", "7", "8", "9", "J", "Q", "K", "A"]
var cSign := ["cardClubs", "cardDiamonds", "cardHearts", "cardSpades"]
var cards := []
var current_card := 1
var current_card_x := 50.0
var current_card_y := 300.0
var current_card_Dealer_x := 50.0
var cards_Dealer := [] 
var double := false
var x := 1.0
var y := 1.0
func _ready():
	# All these functions used to just be a part of the _ready function,
	# But the evil spirits that haunt my code don't allow me to be happy,
	# but at least they force me to make the code seem prettier than it is
	initialize_ui()
	shuffle_cards()
	create_cards()
	ui_visib()

func initialize_ui():
	# Initialize the initial user interface state
	$Money.text = "Money: %s" % Global.money
	$CardCounter.text = "Card counter: %s" % Global.Cheat
	$PlayerName.text = Global.PlayerName
   
func shuffle_cards():
	# Shuffle the card numbers and signs for variety
	randomize()
	cNumb.shuffle()
	cSign.shuffle()

func create_cards():
	# Loop through each sign and number to create cards
	for s in cSign:
		for r in cNumb:
			var _card = Card.instance()
			_card.cSign = s
			_card.cNumb = r
			set_card_value(_card, r)
			position_card(_card)
			add_card_to_scene(_card)

func set_card_value(_card, r):
	# Set the card's value based on the card number
	if r in "23456789":
		_card.value = int(r)
	elif r == "A":
		if Global.count <=10:
			_card.value = 11
		else:
			_card.value = 1
	elif r in "JQK":
		_card.value = 10

func position_card(_card):
	# Position the card in the game space
	_card.position.x = x
	_card.position.y = y
	y += 2.0

func add_card_to_scene(_card):
	# Add the card to the "cards" group and attach it to the scene
	_card.add_to_group("cards")
	call_deferred("add_child", _card)

func ui_visib():
	# Set visibility of UI elements
	$Hit.visible = false
	$Pass.visible = false
	$Double.visible = false
	$PlayerCount.visible = false
	$PlayerName.visible = false
	$CardCounter.visible = false
	$Money.visible = false

	# Hide the close button in the window dialog
	var btn = $WindowDialog.get_close_button()
	btn.visible = false

func btn():
	$Hit.disabled = true
	$Pass.disabled = true

func get_card_value(number: String) -> int:
	$Hit.visible = false
	$Pass.visible = false
	# Hide the close button in the window dialog
	var btn = $WindowDialog.get_close_button()
	btn.visible = false
	return cNumb.find(number) + 2

func addstart() -> void:
	# Retrieve the last card from the deck
	double = false
	var last_card = get_node(".").get_child(get_child_count() - current_card)
	current_card += 1
	current_card_x += 100.0
	last_card.set_position(Vector2(current_card_x, current_card_y))
	last_card.facedown = false
	bjcheck()
	# Apply cheat logic based on the card value
	cheat(last_card.value)

	# Update the player's count and display it in the UI
	Global.count += last_card.value
	$PlayerCount.text = "Count: %s" % Global.count

	# Play a sound effect to signal the addition of a card
	$CardSound.play()

func addplayer() -> void:
	addstart()
	check_count()

func addDealer(_facedown=false) -> void:
	var last_card_dealer = get_node(".").get_child(get_child_count() - current_card)
	cards_Dealer.append(last_card_dealer)
	current_card += 1
	current_card_Dealer_x += 100.0
	last_card_dealer.set_position(Vector2(current_card_Dealer_x, 50.0))
	last_card_dealer.facedown = false
	Global.Dealer_count += last_card_dealer.value
	cheat(last_card_dealer.value)
	if _facedown == true:
		pass
		$DealerCount.text = "Count: %s" % Global.Dealer_count
	$CardSound.play()
	bjcheckdealer()

func _on_Double_pressed():
	addplayer()
	Global.money-=50
	double = true
	$Double.disabled = true

func _on_NewGame_pressed() -> void:
	Global.reset()
	if Global.money > Global.maxmoney:
		Global.maxmoney = Global.money
	$Double.disabled = false
	get_tree().change_scene("res://Main/Main.tscn")

func _on_Exit_pressed() -> void:
	if Global.money > Global.maxmoney:
		Global.maxmoney = Global.money
	Global.updateTopScores()
	get_tree().quit()

func _on_Pass_pressed() -> void:
	cards_Dealer[0].facedown = false
	cards_Dealer[1].facedown = false
	while Global.Dealer_count < 21:
		yield(get_tree().create_timer(1.0), "timeout")
		if Global.Dealer_count <= 17:
			addDealer(true)
		else:
			break
	passcheck()

func _on_Start_pressed() -> void:
	addstart()
	addstart()
	addDealer()
	addDealer()
	if Global.money > Global.maxmoney:
		Global.maxmoney = Global.money
	Global.money-=50

	$Money.text="Money: %s" % Global.money
	$Hit.visible = true
	$Pass.visible = true
	$Start.visible = false
	$Double.visible = true
	$PlayerCount.visible = true
	$PlayerName.visible = true
	$CardCounter.visible = true
	$Money.visible = true

func _on_Hit_pressed():
	addplayer()

func cheat(card_value: int) -> void:
# Function to update card count based on cheat values
	if card_value in [2, 3, 4, 5, 6]:
		Global.Cheat += 1
	elif card_value in [10, 11, 12, 13, 1]: 
		Global.Cheat -= 1
	$CardCounter.text="Card counter: %s" %Global.Cheat

func button():
	$Hit.disabled = true
	$Pass.disabled = true

func print_result() -> String:
	var result = "\n%s: %s\nDealer: %s" % [
		Global.PlayerName, Global.count, Global.Dealer_count
	]
	return result

func check_count() -> void:
	if Global.count > 21:
		lose()

func win() -> void:
	var result = $WindowDialog.get_child(2)
	button()
	$WindowDialog.visible = true
	result.text = "You win :3" + print_result()
	Global.money+=100
	if double==true:
		Global.money+=100
	$WinSound.play()

func lose() -> void:
	var result = $WindowDialog.get_child(2)
	button()
	$WindowDialog.visible = true
	result.text = "You lose :/" + print_result()
	$LossSound.play()
	if Global.money<50:
		get_tree().change_scene("res://Loss/Loss.tscn")

func tie() -> void:
	var result = $WindowDialog.get_child(2)
	button()
	$WindowDialog.visible = true
	result.text = "The round is tied"  + print_result()
	Global.money+=50
	if double==true:
		Global.money+=50
	$TieSound.play()

func bjcheck() -> void:
	#Checks for blackjack at the start of the game
	check_count()
	if Global.count == 21:
		win()
		Global.money+=150

func bjcheckdealer() -> void:
	if Global.Dealer_count == 21:
		lose()

func passcheck() -> void:
	check_count()
	if Global.count > 21:
		lose()
	elif Global.Dealer_count > 21:
		win()
	elif Global.count == Global.Dealer_count: 
		tie()
	elif Global.count<Global.Dealer_count:
		lose()
	else:
		win()



