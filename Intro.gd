extends Node

func _ready():
	pass

func _on_exit_pressed():
	get_tree().quit() 

func _on_bootuptimer_timeout():
	$exit.show()
	
func _on_entertimer_timeout():
	$enter.show()
	
func _on_enter_pressed():
	$enterwar.show()
	$enterwar.play()
	$microtransition.start()
	
func _on_microtransition_timeout():
	$bootup.hide()
	$exit.hide()
	$bootuptimer.stop()
	$enter.hide()
	$transitiontomaintimer.start()

func _on_transitiontomaintimer_timeout():
	get_tree().change_scene("res://main.tscn")