extends Node2D

@export var hp : int = 10
@export var xp : float = 0
@export var level : int = 0
# Called when the node enters the scene tree for the first time.
var location
func _ready():
	
	$"../UI/Progress/Timer".start(.05)
	location = GlobalEventManager.map.castle1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var xp_to_next_level = 5
func add_xp(amount):
	xp += amount
	GlobalEventManager.update_log("Gained " + str(amount) + " xp")
	if(xp >= xp_to_next_level):
		level_up()

func level_up():
	level += 1
	xp -= xp_to_next_level
	xp_to_next_level *= 1.2
	GlobalEventManager.update_log("Player leveled up to " + str(level))

func heal(amount):
	hp+= amount
	GlobalEventManager.update_log("Player healed: " + str(amount))
	GlobalEventManager.update_log("player hp now " + str(hp))
	GlobalEventManager.end_turn(GlobalEventManager.ETurnType.Combat)

func Death():
	GlobalEventManager.HandlePlayerDeath()
	pass

var last_hit_amount : int = 0
func Damage(amount):
	hp -= amount
	hp = max(0, hp)
	last_hit_amount = amount
	#get_node("../HPdisplay").text = str(max(0, hp))
	GlobalEventManager.update_log("Player got hit: " + str(amount) + " damage")
	GlobalEventManager.update_log("Player hp now " + str(hp))
	if(hp <= 0):
		Death()

func Attack(target, amount):
	GlobalEventManager.update_log("Player attacked")
	target.Damage(amount)
	GlobalEventManager.end_turn(GlobalEventManager.ETurnType.Combat)
	pass

func Defend():
	var recover = randi_range(0, last_hit_amount)
	GlobalEventManager.update_log("Player recovered " + str(recover))
	hp += recover
	GlobalEventManager.update_log("Player hp now " + str(hp))
	last_hit_amount = 0
	GlobalEventManager.end_turn(GlobalEventManager.ETurnType.Combat)
	
func Escape():
	if(randf_range(0, 100) < 35):
		GlobalEventManager.update_log("Safely escaped!")
		GlobalEventManager.end_turn(GlobalEventManager.ETurnType.Move1)
		GlobalEventManager.DespawnEnemy
	else:
		GlobalEventManager.update_log("Cannot escape!")
		GlobalEventManager.end_turn(GlobalEventManager.ETurnType.Combat)
		
func Respawn():
	hp = 10
	xp = 0
	level = 0
	location = GlobalEventManager.EnumToLocation(location.respawnpoint)
