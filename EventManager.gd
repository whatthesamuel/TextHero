extends Node2D
class_name EventManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

var logLineNum := 0
func update_log(text : String):
	var logdisplay = $"/root/Scene/UI/Progress/LogDisplay"
	#print(str(logdisplay.text.countn('\n')) + ' ' + str(logdisplay.text.find("\n")))
	print(text)
	logdisplay.text += "\nturn " + str(logLineNum) + ': ' + text
	logLineNum += 1
	if(logdisplay.text.countn('\n') >= 4):
		while(logdisplay.text.countn('\n') >= 4):
			logdisplay.text = logdisplay.text.substr(logdisplay.text.find("\n") + 1)
		pass

func new_event():
	end_turn(ETurnType.values().pick_random())
	pass

enum ETurnType {
	Combat,
	Victory,
	Move1,
	Move2,
	Move3,
	Respawn
}

func end_turn(type : ETurnType):
	var enemy = $"/root/Scene/UI/EnemyRoot/Enemy"
	var CombatButtons = $"/root/Scene/UI/CombatButtons"
	match(type):
		ETurnType.Combat :
			if(enemy.visible):
				enemy.Action()
			else:
				SpawnEnemy()
				CombatButtons.CombatMode()
				
		ETurnType.Victory, ETurnType.Move1, ETurnType.Move2, ETurnType.Move3 :
			MovePlayer()
			CombatButtons.TravelMode()
		ETurnType.Respawn:
			var player = $"/root/Scene/Player"
			DespawnEnemy()
			player.Respawn()
			CombatButtons.TravelMode()	
			pass

# map
#	- - T - -
#	- R R - -
#	T R C T -
#	- - T - -
#	- - - - -

enum EMapType {
	None,
	road1,
	road2,
	road3,
	town1,
	town2,
	town3,
	town4,
	castle1
}

var map = { # number orders from up left
	"town1" : {"name" : "town1", "respawnpoint" : EMapType.town1, "up" : EMapType.None, "right" : EMapType.None, "left" : EMapType.None, "down" : EMapType.road2 },
	"town2" : {"name" : "town2", "respawnpoint" : EMapType.town2, "up" : EMapType.None, "right" : EMapType.road3, "left" : EMapType.None, "down" : EMapType.None },
	"town3" : {"name" : "town3", "respawnpoint" : EMapType.town3, "up" : EMapType.None, "right" : EMapType.None, "left" : EMapType.castle1, "down" : EMapType.None },
	"town4" : {"name" : "town4", "respawnpoint" : EMapType.town4, "up" : EMapType.castle1, "right" : EMapType.None, "left" : EMapType.None, "down" : EMapType.None },
	"castle1" : {"name" : "castle1", "respawnpoint" : EMapType.castle1, "up" : EMapType.road2, "right" : EMapType.town3, "left" : EMapType.road3, "down" : EMapType.town4 },
	"road1" : {"name" : "road1", "respawnpoint" : EMapType.town1, "up" : EMapType.None, "right" : EMapType.road2, "left" : EMapType.None, "down" : EMapType.road3 },
	"road2" : {"name" : "road2", "respawnpoint" : EMapType.castle1, "up" : EMapType.town1, "right" : EMapType.None, "left" : EMapType.road1, "down" : EMapType.road3 },
	"road3" : {"name" : "road3", "respawnpoint" : EMapType.town2, "up" : EMapType.road2, "right" : EMapType.castle1, "left" : EMapType.town2, "down" : EMapType.None },
}

func EnumToLocation(maptype):
	match(maptype):
		EMapType.None:
			print("invalid location!")
			return null
		EMapType.road1:
			return map.road1
		EMapType.road2:
			return map.road2
		EMapType.road3:
			return map.road3
		EMapType.town1:
			return map.town1
		EMapType.town2:
			return map.town2
		EMapType.town3:
			return map.town3
		EMapType.town4:
			return map.town4
		EMapType.castle1:
			return map.castle1

func MovePlayer():
	var direction = randi_range(0, 3)
	var player = $"/root/Scene/Player"
	var currentLocation = player.location
	match(direction):
		0:
			if(currentLocation.up != EMapType.None):
				player.location = EnumToLocation(currentLocation.up)
			pass
		1:
			if(currentLocation.down != EMapType.None):
				player.location = EnumToLocation(currentLocation.down)
			pass
		2:
			if(currentLocation.right != EMapType.None):
				player.location = EnumToLocation(currentLocation.right)
			pass
		3:
			if(currentLocation.left != EMapType.None):
				player.location = EnumToLocation(currentLocation.left)
			pass
	update_log("Player now at: " + player.location.name)
	$"/root/Scene/UI/Progress/Timer".start(.05)
	
func DespawnEnemy():
	var enemy = $"/root/Scene/UI/EnemyRoot/Enemy"
	enemy.visible = false
	$"/root/Scene/UI/Progress/Timer".start(.05)
	pass

func SpawnEnemy():
	var enemy = $"/root/Scene/UI/EnemyRoot/Enemy"
	enemy.visible = true
	enemy.Spawn()
	$"/root/Scene/UI/Progress/Timer".stop()
	pass

func RespawnPlayer():
	end_turn(ETurnType.Respawn)
	update_log("Player respawned!")
	pass
	
func HandlePlayerDeath():
	var player = $"/root/Scene/Player"
	$"/root/Scene/UI/CombatButtons".RespawnMode()
	$"/root/Scene/UI/Progress/Timer".stop()
	pass
