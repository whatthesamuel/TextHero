extends Control

@onready var AttackButton = $ButtonList/AttackButton
@onready var EscapeButton = $ButtonList/EscapeButton
@onready var DefendButton = $ButtonList/DefendButton
@onready var RespawnButton = $ReSpawnButton
@onready var XPButton = $XPButton
@onready var player = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	AttackButton.pressed.connect(Attack)
	EscapeButton.pressed.connect(Escape)
	DefendButton.pressed.connect(Defend)
	RespawnButton.pressed.connect(Respawn)
	XPButton.pressed.connect(GiveXP)
	
	TravelMode()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func Attack():
	var enemy = $"../EnemyRoot/Enemy"
	player.Attack(enemy, randi_range(1,3))
	pass

func Defend():
	player.Defend()
	pass
	
func Escape():
	player.Escape()
	pass

func Respawn():
	GlobalEventManager.RespawnPlayer()
	pass
	
func GiveXP():
	player.add_xp(1)

func CombatMode():
	var ButtonList = $ButtonList
	ButtonList.visible = true
	var buttons = ButtonList.get_children()
	for b in buttons:
		b.disabled = false
		b.visible = true
	RespawnButton.visible = false
	RespawnButton.disabled = true
	XPButton.visible = false
	XPButton.disabled = true
	
	
func RespawnMode():
	var ButtonList = $ButtonList
	ButtonList.visible = false
	var buttons = ButtonList.get_children()
	for b in buttons:
		b.disabled = true
		b.visible = false
		
	RespawnButton.visible = true
	RespawnButton.disabled = false
	
	XPButton.visible = false
	XPButton.disabled = true

func TravelMode():
	var ButtonList = $ButtonList
	ButtonList.visible = false
	var buttons = ButtonList.get_children()
	for b in buttons:
		b.disabled = true
		b.visible = false
		
	RespawnButton.visible = false
	RespawnButton.disabled = true
	
	XPButton.visible = true
	XPButton.disabled = false
