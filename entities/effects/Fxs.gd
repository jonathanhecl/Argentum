extends AnimatedSprite2D

func intialize(spriteFrames:SpriteFrames):
	var frames = spriteFrames
	play("default")

func _on_Fxs_animation_finished() -> void:
	queue_free()
