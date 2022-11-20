extends PanelContainer

var card = null

export var afford_color: Color = Color.green
export var no_afford_color: Color = Color.red

export var null_color: Color = Color.gray

var bought = false

func _ready():
	if card == null:
		$MainContainer/Control.visible = false
		$MainContainer/NullLabel.visible = true
		$MainContainer/NullLabel.modulate = null_color
		return
	$"%CostLabel".text = str(card.cost)

func _process(delta):
	if card == null:
		return
	$"%BuyButton".disabled = bought || Game.money < card.cost
	$"%CostLabel".modulate = no_afford_color if Game.money < card.cost else afford_color


func _on_BuyButton_pressed():
	Game.money -= card.cost
	bought = true
	Deck.add_card(card)
	$"%BuyButton".disabled = true
	$"%BuyButton".focus_mode = Control.FOCUS_NONE
	$"%BuyButton".text = "Purchased!"
	$"%BuyButton".icon = null
	$"%CostLabel".visible = false
