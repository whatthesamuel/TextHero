extends Node2D

@onready var player = $"../../../Player"
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

@export var health : int
@export var enemyname : String
var level : int
var given_xp
func Spawn():
	visible = true
	level = randi_range(roundi(player.level / 2), roundi(player.level + player.level/2))
	health = randi_range(5, 10)
	given_xp = randi_range(5, 10)
	enemyname = "Enemy"
	GlobalEventManager.update_log(enemyname + " has appeared!\nenemy hp: " + str(health))

func Death():
	player.add_xp(given_xp)
	GlobalEventManager.update_log("Enemy is dead")
	GlobalEventManager.update_log("xp gain: " + str(given_xp))
	GlobalEventManager.DespawnEnemy()
	pass

var last_hit_amount : int = 0
func Damage(amount):
	last_hit_amount = amount
	health -= amount
	health = max(0, health)
	#get_node("../HPdisplay").text = str(max(0, health))
	GlobalEventManager.update_log("Enemy got hit: " + str(amount) + " damage")
	GlobalEventManager.update_log("Enemy hp now " + str(health))
	if(health <= 0):
		Death()

func Defend():
	var recover = randi_range(1, last_hit_amount)
	health += recover
	GlobalEventManager.update_log("Enemy recovered " + str(recover))
	GlobalEventManager.update_log("Enemy hp now " + str(health))
	last_hit_amount = 0

func Action():
	if(health <=0):
		return
	var choice = randi_range(0, 10)
	var amount = randi_range(1, 5)
	match(choice):
		0: 
			GlobalEventManager.update_log("Enemy is glaring at player...")
			pass
		1,2,3,4: #attack
			GlobalEventManager.update_log("Enemy Attacked!")
			player.Damage(amount)
		5,6,7: #defend
			if(last_hit_amount > 0):
				Defend()
			pass
		8: #use item
			GlobalEventManager.update_log("Enemy used item ")
			GlobalEventManager.update_log("Enemy hp now " + str(health))
			pass
		9,10: #flee
			GlobalEventManager.update_log("Enemy ran away")
			GlobalEventManager.end_turn(GlobalEventManager.ETurnType.Victory)
			GlobalEventManager.DespawnEnemy()
			pass

func Despawn():
	visible = false
	pass
