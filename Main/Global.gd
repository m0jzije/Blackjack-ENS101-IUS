extends Node

# Global node/script set up as AutoLoad, 
# meaning it is running at all times and its contents can be used in other scripts
var PlayerName = "Player"
var money = 200
var maxmoney = 0
var Cheat = 0
var count = 0
var Dealer_count = 0

var topScoreString1: String = " "
var topScoreString2: String = " "
var topScoreString3: String = " "
var topScoreString4: String = " "
var topScoreString5: String = " "
var highScores = []
var top5ScoresValues : Array = []

func _ready():
	loadHighScores()

func loadHighScores():
	var file = File.new()
	if file.file_exists("user://high_scores.txt"):
		file.open("user://high_scores.txt", File.READ)
		highScores = []
		while !file.eof_reached():
			var line = file.get_line()
			if line != "":
				highScores.append(JSON.parse(line))
	file.close()

func updateTopScores():
	var updated = false

	# Ensure highScores is a JSON array
	if highScores is Array:
		# Iterate through the top 5 scores in descending order
		for i in range(highScores.size() - 1, -1, -1):
			var currentScore = highScores[i]
			
			# Ensure the current score has a 'score' field
			if "score" in currentScore and maxmoney > currentScore["score"]:
				# Insert the new score at this position in both highScores and top5ScoresValues
				highScores.insert(i + 1, {"playerName": PlayerName, "score": maxmoney})
				top5ScoresValues.insert(i + 1, maxmoney)
				updated = true
				break

		# If the list was not updated, and the size is less than 5, append the new score in both arrays
		if !updated and highScores.size() < 5:
			highScores.insert(0, {"playerName": PlayerName, "score": maxmoney})
			top5ScoresValues.insert(0, maxmoney)

		# Trim both lists to keep only the top 5 scores
		highScores.resize(5)
		top5ScoresValues.resize(5)
	updateTopScoreStrings()
	saveHighScores()

func saveHighScores():
	var file = File.new()
	file.open("user://high_scores.txt", File.WRITE)
	for score in highScores:
		file.store_line(to_json(score))
	file.close()

func updateTopScoreStrings() -> void:
	for i in range(1, 6):
		if i - 1 < highScores.size():
			var currentScoreString = "%d: %s - $%d" % [i, highScores[i - 1]["PlayerName"], highScores[i - 1]["score"]]
			match i:
				1: topScoreString1 = currentScoreString
				2: topScoreString2 = currentScoreString
				3: topScoreString3 = currentScoreString
				4: topScoreString4 = currentScoreString
				5: topScoreString5 = currentScoreString
		else:
			match i:
				1: topScoreString1 = ""
				2: topScoreString2 = ""
				3: topScoreString3 = ""
				4: topScoreString4 = ""
				5: topScoreString5 = ""

func reset():
	count = 0
	Dealer_count = 0

func hreset():
	reset()
	PlayerName = "Player"
	money = 200
	Cheat = 0
	maxmoney = 0

