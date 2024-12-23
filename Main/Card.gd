extends Node2D
class_name Card

var cSign: String
var cNumb: String
var value: int
var facedown = true

# Function to get the numeric value of the card
func getvalue() -> int:
	return value

# Function to get the number and sign of the card as a string
func getinfo() -> String:
	return cSign + cNumb

func _ready():
	# Initialize the card's texture
	$Texture.texture_normal = load('res://Main/Textures/%s%s.png' % [cSign, cNumb])

# Check if the card is facedown and disable its texture accordingly
func _process(_delta):
	if facedown:
		$Texture.disabled = true
	else:
		$Texture.disabled = false
