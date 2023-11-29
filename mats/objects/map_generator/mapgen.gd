extends TileMap
@export var size:Vector2i=Vector2i(0,0)
@export var offset:Vector2i=Vector2i.ZERO
@export_range(-1,999999999999999)var seed:int=-1
@export_range(1,999999) var curve_steps:int=5
var curve:Curve=Curve.new()
var rnd=RandomNumberGenerator.new()
func rand_land_height(safe_count:int=3):
	var t=snapped(rnd.randf_range(-0.6,0.6),0.01)
	var i=0
	while (t>1 or t<0) and i<safe_count:
		t=snapped(rnd.randf_range(-0.6,0.6),0.01)
		i+=1
	if i>=safe_count:
		print(curve.get_point_position(curve.get_point_count()-1).y," ",t)
	return t
func rec(steps:int=3,start:float=0,end:float=1):
	var t=start+(end-start)/2
	var rand_add=snapped(rnd.randf_range(-0.6,0.6),0.01)
	#rnd.seed+=1
	var y = curve.get_point_position(curve.get_point_count()-1).y
	curve.add_point(Vector2(t,y+rand_add))
	if steps>0:
		rec(steps-1,start,t)
		rec(steps-1,t,end)
func has_heighbor(p:PackedVector2Array,e:Vector2i,vec:Vector2i):
	return p.has(e+vec)
# Called when the node enters the scene tree for the first time.
func _ready():
	if seed!=-1:
		rnd.seed=seed
	else:
		rnd.seed=fnc.rnd.seed
		rnd.randomize()
	curve.add_point(Vector2(0,1))
	curve.add_point(Vector2(1,1))
	rec(curve_steps,0,1)
	var pool:PackedVector2Array=PackedVector2Array([])
	var step:int=rnd.randi_range(20,50)
	var last_y=curve.sample(0)*size.y
	var x:int=0
	set_cells_terrain_connect(0,PackedVector2Array([Vector2i(0,0),Vector2i(500,500)]),0,0)
	while x<size.x:
		var cur_y=ceil(curve.sample(float(x)/float(size.x))*size.y)
		for y in range(cur_y):
			for e in range(0,step):
				pool.append(Vector2i(x+e,-y)+offset)
		if abs(last_y-cur_y)>=6:
			var jp=preload("res://mats/objects/jumppad/area_2d.tscn").instantiate()
			if cur_y>last_y:
				jp.position=(Vector2i(x-1,-last_y+1)+offset)*16
			else:
				jp.position=(Vector2i(x+1,-cur_y+1)+offset)*16
			jp.height=abs(last_y-cur_y)*16
			add_child(jp)
		last_y=cur_y
		x+=step
		step=rnd.randi_range(10,20)
	
	set_cells_terrain_connect(0,pool,0,0)
