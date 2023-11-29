extends Polygon2D
@export var w:int=1
@export var lines:PackedVector2Array
var col=CollisionPolygon2D.new()
func _ready():
	var pol=PackedVector2Array([])
	for e in lines:
		pol.append(fnc.move(e.x+90)*e.y)
	if w!=0:
		for o in range(0,len(lines)):
			var i=lines[len(lines)-o-1]
			pol.append(fnc.move(i.x+90)*(i.y+w))
	polygon=pol
	col.polygon=polygon
	get_parent().add_child(col)

	
