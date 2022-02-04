extends Camera2D

onready var CAMERA_TOPLEFT = $Limits/TopLeft
onready var CAMERA_BOTTOMRIGHT = $Limits/BottomRight

func _ready():
	limit_top = CAMERA_TOPLEFT.position.y
	limit_left = CAMERA_TOPLEFT.position.x
	limit_bottom = CAMERA_BOTTOMRIGHT.position.y
	limit_right = CAMERA_BOTTOMRIGHT.position.x
