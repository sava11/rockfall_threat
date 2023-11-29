extends "res://mats/objects/boxes/hitbox.gd"
@export var drawing:bool=false
@export var del_time:float=0.0
@export var autoset:bool=false
@onready var obj=get_node_or_null("c")
func _ready():
	if del_time!=0.0:
		$t.autostart=true
		$t.start(del_time)
	
func think(v):
	if obj==null:
		if v is PackedVector2Array:
			obj=CollisionPolygon2D.new()
			obj.polygon=v
			var xs=[]
			var ys=[]
			for e in v:
				xs.append(e.x)
				ys.append(e.y)
			$r.target_position.x=fnc._sqrt(Vector2(fnc.sum(xs),fnc.sum(ys)))
		elif v is Vector2:
			obj=CollisionShape2D.new()
			obj.shape=RectangleShape2D.new()
			obj.shape.size=v
			$r.target_position.x=fnc._sqrt(v)
		elif v is float or v is int:
			obj=CollisionShape2D.new()
			obj.shape=CircleShape2D.new()
			obj.shape.radius=v
			$r.target_position.x=v
		obj.name="c"
		add_child(obj)
func _draw():
	if drawing:
		if obj is CollisionPolygon2D:
			draw_polygon(obj.polygon,PackedColorArray([Color(1.0,0,0,0.5)]))
		elif obj is CollisionShape2D:
			if obj.shape is RectangleShape2D:
				draw_rect(Rect2(obj.shape.size-obj.shape.size/2,obj.shape.size),Color(1.0,0,0,0.5),true)
			elif obj.shape is CircleShape2D:
				draw_circle(Vector2.ZERO,obj.shape.radius,Color(1,0,0,0.5))
func _physics_process(delta):
	queue_redraw()
