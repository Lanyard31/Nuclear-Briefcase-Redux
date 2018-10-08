extends Node

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if global.howtoplay == 0:
			return
		if global.howtoplay == 1:
			global.howtoplay = 2
			$howtoplay.show()
			$entertimer/ESC.hide()
			$entertimer/ESCback.show()
			$clicker.play()
		else:
			global.howtoplay = 1
			$howtoplay.hide()
			$entertimer/ESCback.hide()
			$entertimer/ESC.show()
			$clicker.play()

func _on_exit_pressed():
	$clicker.play()
	$quitter.start() 

func _on_bootuptimer_timeout():
	$exit.show()
	$entertimer/ESC.show()
	global.howtoplay = 1
	
func _on_entertimer_timeout():
	$enter.show()
	
func _on_enter_pressed():
	$enterwar.show()
	$enterwar.play()
	$microtransition.start()
	global.howtoplay = 0
	$howtoplay.hide()
	$entertimer/ESCback.hide()
	$entertimer/ESC.hide()
	$clicker.play()
	
	
func _on_microtransition_timeout():
	$bootup.hide()
	$exit.hide()
	$sirentimer.start()
	$entertimer/ESC.hide()
	$bootuptimer.stop()
	$enter.hide()
	$alarmsound
	$transitiontomaintimer.start()
	$startreadypop.start()

func _on_transitiontomaintimer_timeout():
	get_tree().change_scene("res://main.tscn")

func _on_startsound_timeout():
	$enterwarsound.play()

func _on_startreadypop_timeout():
	$startready.show()
	
func _on_sirentimer_timeout():
	$startgamesiren.play()
	
func _on_quitter_timeout():
	get_tree().quit()
