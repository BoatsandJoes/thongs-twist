extends Node2D
class_name Square

const size = 150
const sprite_size = 50
const texture = preload("res://assets/sprites/board.png")
var colors: Dictionary[Vector2i, int]
var colorChoices: int = 4
var sprites: Dictionary[Vector2i, Array] = {
	Vector2i(0,1): [], Vector2i(0,-1): [], Vector2i(1,0): [], Vector2i(-1,0): []
	}

func _ready() -> void:
	random()

func random() -> void:
	colors[Vector2i(0,1)] = randi_range(0, colorChoices - 1)
	colors[Vector2i(0,-1)] = randi_range(0, colorChoices - 1)
	colors[Vector2i(1,0)] = randi_range(0, colorChoices - 1)
	colors[Vector2i(-1,0)] = randi_range(0, colorChoices - 1)
	var opposites: Array[int] = []
	if(colors[Vector2i(0,1)] == colors[Vector2i(0,-1)]
	&& colors[Vector2i(0,1)] != colors[Vector2i(1,0)] && colors[Vector2i(0,1)] != colors[Vector2i(-1,0)]):
		opposites.append(colors[Vector2i(0,1)])
	if(colors[Vector2i(1,0)] == colors[Vector2i(-1,0)]
	&& colors[Vector2i(1,0)] != colors[Vector2i(0,1)] && colors[Vector2i(1,0)] != colors[Vector2i(0,-1)]):
		opposites.append(colors[Vector2i(1,0)])
	if !opposites.is_empty():
		colors[Vector2i(0,0)] = opposites[randi_range(0, opposites.size() - 1)]
	update_visuals()

func twist(clockwise: bool):
	var temp = colors[Vector2i(0,1)]
	if clockwise:
		colors[Vector2i(0,1)] = colors[Vector2i(1,0)]
		colors[Vector2i(1,0)] = colors[Vector2i(0,-1)]
		colors[Vector2i(0,-1)] = colors[Vector2i(-1,0)]
		colors[Vector2i(-1,0)] = temp
	else:
		colors[Vector2i(0,1)] = colors[Vector2i(-1,0)]
		colors[Vector2i(-1,0)] = colors[Vector2i(0,-1)]
		colors[Vector2i(0,-1)] = colors[Vector2i(1,0)]
		colors[Vector2i(1,0)] = temp
	update_visuals()

func update_visuals():
	if sprites[Vector2i(1,0)].is_empty():
		for group in sprites.keys():
			for i in range(4):
				var sprite = Sprite2D.new()
				sprite.texture = texture
				sprite.hframes = 24
				sprite.vframes = 4
				sprites[group].append(sprite)
				#set position
				if i == 0:
					sprite.position = group * sprite_size
					if group.y != 0:
						sprite.position.x = sprite.position.x - sprite_size
					elif group.x != 0:
						sprite.position.y = sprite.position.y - sprite_size
				elif i == 1:
					sprite.position = group * sprite_size
				elif i == 2:
					sprite.position = group * sprite_size
					if group.y != 0:
						sprite.position.x = sprite.position.x + sprite_size
					elif group.x != 0:
						sprite.position.y = sprite.position.y + sprite_size
				add_child(sprite)
	for group in sprites.keys():
		for i in range(4):
			sprites[group][i].visible = true
			#set color
			sprites[group][i].frame_coords.y = colors[group]
			#set shape todo
			if i == 0:
				if group == Vector2i(-1, 0):
					if colors[Vector2i(0, -1)] == colors[group]:
						sprites[group][i].frame_coords.x = 15
					else:
						sprites[group][i].frame_coords.x = 19
				elif group == Vector2i(1, 0):
					if colors[Vector2i(0, -1)] == colors[group]:
						sprites[group][i].frame_coords.x = 15
					else:
						sprites[group][i].frame_coords.x = 18
				elif group == Vector2i(0, 1):
					if colors[Vector2i(-1, 0)] == colors[group]:
						sprites[group][i].frame_coords.x = 15
					else:
						sprites[group][i].frame_coords.x = 18
				elif group == Vector2i(0, -1):
					if colors[Vector2i(-1, 0)] == colors[group]:
						sprites[group][i].frame_coords.x = 15
					else:
						sprites[group][i].frame_coords.x = 17
			elif i == 1:
				if colors.has(Vector2i(0,0)):
					if colors[Vector2i(0,0)] == colors[group]:
						sprites[group][i].frame_coords.x = 15
					else:
						if group == Vector2i(-1, 0):
							sprites[group][i].frame_coords.x = 14
						elif group == Vector2i(1, 0):
							sprites[group][i].frame_coords.x = 12
						elif group == Vector2i(0, 1):
							sprites[group][i].frame_coords.x = 13
						elif group == Vector2i(0, -1):
							sprites[group][i].frame_coords.x = 11
				else:
					var loneRanger: bool = true
					var otherColor: int = -1
					for key in sprites.keys():
						if key != group:
							if (colors[key] == colors[group]
							|| (otherColor != -1 && colors[key] != otherColor)):
								loneRanger = false
								break
							else:
								otherColor = colors[key]
					if !loneRanger:
						sprites[group][i].frame_coords.x = 15
					else:
						if group == Vector2i(-1, 0):
							sprites[group][i].frame_coords.x = 14
						elif group == Vector2i(1, 0):
							sprites[group][i].frame_coords.x = 12
						elif group == Vector2i(0, 1):
							sprites[group][i].frame_coords.x = 13
						elif group == Vector2i(0, -1):
							sprites[group][i].frame_coords.x = 11
			elif i == 2:
				if group == Vector2i(-1, 0):
					if colors[Vector2i(0, 1)] == colors[group]:
						sprites[group][i].frame_coords.x = 15
					else:
						sprites[group][i].frame_coords.x = 16
				elif group == Vector2i(1, 0):
					if colors[Vector2i(0, 1)] == colors[group]:
						sprites[group][i].frame_coords.x = 15
					else:
						sprites[group][i].frame_coords.x = 17
				elif group == Vector2i(0, 1):
					if colors[Vector2i(1, 0)] == colors[group]:
						sprites[group][i].frame_coords.x = 15
					else:
						sprites[group][i].frame_coords.x = 19
				elif group == Vector2i(0, -1):
					if colors[Vector2i(1, 0)] == colors[group]:
						sprites[group][i].frame_coords.x = 15
					else:
						sprites[group][i].frame_coords.x = 16
			elif i == 3:
				if colors.has(Vector2i(0,0)):
					if colors[Vector2i(0,0)] == colors[group]:
						if group.x == 0:
							sprites[group][i].frame_coords.x = 6
						else:
							sprites[group][i].frame_coords.x = 9
					else:
						sprites[group][i].visible = false
				else:
					if group == Vector2i(-1,0):
						if colors[Vector2i(0,1)] == colors[group]:
							if colors[Vector2i(1,0)] == colors[group]:
								if colors[Vector2i(0,-1)] == colors[group]:
									sprites[group][i].frame_coords.x = 15
								else:
									sprites[group][i].frame_coords.x = 13
							else:
								if colors[Vector2i(0,-1)] == colors[group]:
									sprites[group][i].frame_coords.x = 14
								else:
									sprites[group][i].frame_coords.x = 19
						else:
							if colors[Vector2i(1,0)] == colors[group]:
								if colors[Vector2i(0,-1)] == colors[group]:
									sprites[group][i].frame_coords.x = 11
								else:
									pass #handled by "opposites" scenario
							else:
								if colors[Vector2i(0,-1)] == colors[group]:
									sprites[group][i].frame_coords.x = 16
								else:
									if (colors[Vector2i(0,-1)] == colors[Vector2i(0,1)]
									&& colors[Vector2i(0,-1)] == colors[Vector2i(1,0)]):
										sprites[group][i].visible = false
									else:
										sprites[group][i].frame_coords.x = 20
					elif group == Vector2i(1,0):
						if colors[Vector2i(0,1)] == colors[group]:
							if colors[Vector2i(-1,0)] == colors[group]:
								if colors[Vector2i(0,-1)] == colors[group]:
									sprites[group][i].frame_coords.x = 15
								else:
									sprites[group][i].frame_coords.x = 13
							else:
								if colors[Vector2i(0,-1)] == colors[group]:
									sprites[group][i].frame_coords.x = 12 #xxx
								else:
									sprites[group][i].frame_coords.x = 18
						else:
							if colors[Vector2i(-1,0)] == colors[group]:
								if colors[Vector2i(0,-1)] == colors[group]:
									sprites[group][i].frame_coords.x = 11
								else:
									pass #handled by "opposites" scenario
							else:
								if colors[Vector2i(0,-1)] == colors[group]:
									sprites[group][i].frame_coords.x = 17
								else:
									if (colors[Vector2i(0,-1)] == colors[Vector2i(0,1)]
									&& colors[Vector2i(0,-1)] == colors[Vector2i(-1,0)]):
										sprites[group][i].visible = false
									else:
										sprites[group][i].frame_coords.x = 22
					elif group == Vector2i(0,-1):
						if colors[Vector2i(1,0)] == colors[group]:
							if colors[Vector2i(0,1)] == colors[group]:
								if colors[Vector2i(-1,0)] == colors[group]:
									sprites[group][i].frame_coords.x = 15
								else:
									sprites[group][i].frame_coords.x = 12
							else:
								if colors[Vector2i(-1,0)] == colors[group]:
									sprites[group][i].frame_coords.x = 11
								else:
									sprites[group][i].frame_coords.x = 17
						else:
							if colors[Vector2i(0,1)] == colors[group]:
								if colors[Vector2i(-1,0)] == colors[group]:
									sprites[group][i].frame_coords.x = 14
								else:
									pass #handled by "opposites" scenario
							else:
								if colors[Vector2i(-1,0)] == colors[group]:
									sprites[group][i].frame_coords.x = 16
								else:
									if (colors[Vector2i(-1,0)] == colors[Vector2i(0,1)]
									&& colors[Vector2i(1,0)] == colors[Vector2i(-1,0)]):
										sprites[group][i].visible = false
									else:
										sprites[group][i].frame_coords.x = 21
					elif group == Vector2i(0,1):
						if colors[Vector2i(1,0)] == colors[group]:
							if colors[Vector2i(0,-1)] == colors[group]:
								if colors[Vector2i(-1,0)] == colors[group]:
									sprites[group][i].frame_coords.x = 15
								else:
									sprites[group][i].frame_coords.x = 12
							else:
								if colors[Vector2i(-1,0)] == colors[group]:
									sprites[group][i].frame_coords.x = 13
								else:
									sprites[group][i].frame_coords.x = 18
						else:
							if colors[Vector2i(0,-1)] == colors[group]:
								if colors[Vector2i(-1,0)] == colors[group]:
									sprites[group][i].frame_coords.x = 14
								else:
									pass #handled by "opposites" scenario
							else:
								if colors[Vector2i(-1,0)] == colors[group]:
									sprites[group][i].frame_coords.x = 19
								else:
									if (colors[Vector2i(-1,0)] == colors[Vector2i(0,1)]
									&& colors[Vector2i(1,0)] == colors[Vector2i(-1,0)]):
										sprites[group][i].visible = false
									else:
										sprites[group][i].frame_coords.x = 23
