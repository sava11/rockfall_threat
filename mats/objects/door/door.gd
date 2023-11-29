extends Node2D
@export var open:bool=false
@export_range(0,9999999) var up:float=100#
@export var auto_up:bool=false
@export_range(0,9999999) var speed:float=100.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var pos=$d.position.y
# Called when the node enters the scene tree for the first time.
func _ready():
	if auto_up==true:
		var t=get_node("p").polygon
		var maxX=0
		for e in t:
			if e.y>maxX:
				maxX=e.y
		up=maxX
	pass # Replace with function body.
func _physics_process(delta):
	$d.position.y=move_toward($d.position.y,pos-up*int(open),delta*speed)



func _on_lock_activated(a):
	open=a
