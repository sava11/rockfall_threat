class_name hitbox extends Area2D
@export var by_time:bool=false
@export var damage:float=1.0
@export var crit_damage:float=2.0
@export var crit_chance:float=0.0

func _on_timer_timeout():
	queue_free()
