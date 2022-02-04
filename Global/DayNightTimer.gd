extends CanvasModulate

export (int)var SECONDS = 0
export (int)var MINUTES = 0
export (int)var HOURS = 0
export (int)var SOLS = 0

#Default speeds are 80

const TIME_SPEED_DEFAULT = 800

var TIME_SPEED = 800

func _ready():
	TIME_SPEED = TIME_SPEED_DEFAULT
	
	
func _process(delta):
	if TIME_SPEED > 0:
		SECONDS += int(floor(delta * TIME_SPEED))
		MINUTES = (int(SECONDS) / 60) % 60
		HOURS = (int(SECONDS) / 3600) % 24
		SOLS = (int(SECONDS) / 86400)
		
	print (MINUTES)
	print (HOURS)
	print (SOLS)
	
	
	var TIME_IN_SECONDS = SECONDS
	var CURRENT_FRAME = range_lerp(TIME_IN_SECONDS,0,86400,0,24)
	$AnimationPlayer.play("DayNight")
	$AnimationPlayer.seek(CURRENT_FRAME)
