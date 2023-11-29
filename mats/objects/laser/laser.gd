extends Node2D
@export_range(1,99999)var width:float=5
@onready var r=$r
@onready var hib=$hirtbox
func _physics_process(delta):
	hib.get_node("c").shape.size.x=width
	hib.get_node("c").shape.size.y=fnc._sqrt(r.get_collision_point()-r.global_position)
	hib.get_node("c").position.y=-hib.get_node("c").shape.size.y/2
	$l.points[1].y=-fnc._sqrt(r.get_collision_point()-r.global_position)
	$l.width=width
	
func _on_lock_activated(active):
	hib.monitorable=!active
	hib.monitoring=!active
	$l.visible=!active
