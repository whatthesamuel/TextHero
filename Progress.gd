extends Control

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_timer_timeout():
	if($ProgressBar.value >= $ProgressBar.max_value):
		GlobalEventManager.new_event()
		$ProgressBar.value = 0
	$ProgressBar.value += 1
	pass # Replace with function body.
