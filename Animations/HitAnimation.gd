extends Node2D


onready var ANIMATION_SPRITE = $AnimatedSprite


func _ready():
	ANIMATION_SPRITE.frame = 0
	ANIMATION_SPRITE.play("Animation")

func _on_AnimatedSprite_animation_finished():
	queue_free()
