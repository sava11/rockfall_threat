extends TileMap
@export var size:Vector2i=Vector2i(0,0)
@export var offset:Vector2i=Vector2i.ZERO
@export var xsize:int=1
@export_range(-1,999999999999999)var seed:int=-1
@export_range(1,999999) var curve_steps:int=5
var curve:Curve=Curve.new()
var rnd=RandomNumberGenerator.new()
func rec(steps:int=3,start:float=0,end:float=1):
	var t=start+(end-start)/2
	var rand_add=snapped(rnd.randf_range(-0.1,0.2),0.05)
	#rnd.seed+=1
	var y = curve.get_point_position(curve.get_point_count()-1).y
	
	if rand_add<0:
		curve.add_point(Vector2(t,y+rand_add))
		curve.add_point(Vector2(t,y-rand_add))
	else:
		curve.add_point(Vector2(t,y-rand_add))
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
	for x in range(0,size.x):
		for y in range(ceil(curve.sample(float(x)/float(size.x))*size.y)):
			pool.append(Vector2i(x,-y)+offset)
	var i:int=0
	while i<pool.size():
		var e=pool[i]
		if !(has_heighbor(pool,e,Vector2i(-1,0)) or has_heighbor(pool,e,Vector2i(1,0))):
			pool.remove_at(i)
			i-=1
		i+=1
	set_cells_terrain_connect(0,pool,0,0)
