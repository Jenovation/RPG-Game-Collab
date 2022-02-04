extends StaticBody2D


func create_animation():
	var HIT_ANIMATION = load("res://Animations/HitAnimation.tscn")
	var PLAY = HIT_ANIMATION.instance()
	var WORLD = get_tree().current_scene
	WORLD.add_child(PLAY)
	PLAY.global_position = global_position
	
	
func _on_Hurtbox_area_entered(_area):
	#This plays the Hit Animation
	create_animation()
	#This deletes the sprite (CoralTree) after the animation is done. Remove to keep the sprite there.
	queue_free()
