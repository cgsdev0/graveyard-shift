tool
extends Spatial

export var header_tint: Color = Color.red setget _set_header_tint
export var header = 0.0 setget _set_header
export var decal_bits = 0 setget _set_decal_bits
export var decal_scale = 1.0 setget _set_decal_scale
export var decal_v_offset = 0.0 setget _set_decal_v_offset

var selection_glow_shader = preload("res://shaders/selection_glow.tres")
var treasure_glow_shader = preload("res://shaders/treasure_glow.tres")

var glass_card_shader = preload("res://shaders/glass_card_shader.tres")

var blank = preload("res://textures/blank.png")

var wall_n = preload("res://textures/cards/walls/N.png")
var wall_s = preload("res://textures/cards/walls/S.png")
var wall_e = preload("res://textures/cards/walls/E.png")
var wall_w = preload("res://textures/cards/walls/W.png")

var textures = {
	Game.TileType.EMPTY: [
		preload("res://textures/cards/grass_1.png"),
		preload("res://textures/cards/grass_2.png"),
		preload("res://textures/cards/grass_3.png"),
		preload("res://textures/cards/grass_4.png"),
	],
	Game.TileType.MONEY_TREE: [ preload("res://textures/cards/money_tree.png") ],
	Game.TileType.LURE: [ preload("res://textures/cards/lure.png") ],
	Game.TileType.TRAP: [ preload("res://textures/cards/trap.png") ],
	Game.TileType.GUST: [ preload("res://textures/cards/gust_of_wind.png") ],
	Game.TileType.WALL: [ wall_n, wall_s, wall_e, wall_w ],
	Game.TileType.SECRET_DOOR: [ wall_n, wall_s, wall_e, wall_w ],
	Game.TileType.BRIDGE: [ preload("res://textures/cards/bridge_horizontal.png"), blank, preload("res://textures/cards/bridge_vertical.png"), blank ],
	Game.TileType.COURAGE: [ preload("res://textures/cards/courage.png") ],
	Game.TileType.ACTION_SURGE: [ preload("res://textures/cards/action_surge.png") ],
	Game.TileType.FORESIGHT: [ preload("res://textures/cards/foresight.png") ],
	Game.TileType.FRESH_START: [ preload("res://textures/cards/fresh_start.png") ],
	Game.TileType.TREASURE: [ preload("res://textures/cards/treasure.png") ],
	Game.TileType.TREASURE_TAKEN: [ preload("res://textures/cards/treasure_taken.png") ],
}

var bg_textures = {
	Game.TileType.PIT: preload("res://textures/cards/pit.png"),
	Game.TileType.SPIKES: preload("res://textures/cards/spikes.png"),
}

func become(card):
	if card == null:
		return
	
	override_bg(bg_textures.get(card.type, null))
	recompute_wall_decals(card)
	
	match card.type:
		Game.TileType.PIT, Game.TileType.EMPTY, Game.TileType.EXIT, Game.TileType.TREASURE, Game.TileType.TREASURE_TAKEN, Game.TileType.TRAP_SPRUNG:
			return
	
	match card.type:
		Game.TileType.COURAGE, Game.TileType.GUST:
			self.set_bg_hue_shift(-2.072)
		Game.TileType.ACTION_SURGE, Game.TileType.FORESIGHT, Game.TileType.FRESH_START:
			self.set_bg_hue_shift(11.0)
		_:
			self.set_bg_hue_shift(0.0)
			
	self.set_text(str(card.ac), Game.title_card(card))
	self._set_header_tint(Deck.card_color(card))
	self.enable_hearts(0)
	if Game.is_wall(card.type):
		match card.type:
			Game.TileType.WALL, Game.TileType.SECRET_DOOR:
				var n = card.wall_flags.max()
				if n < 1000:
					enable_hearts(n)

func set_bg_hue_shift(v):
	$Plane.get_surface_material(0).set_shader_param("bg_hue", v)
	
func recompute_wall_decals(card):
	if card == null || !textures.has(card.type):
		return
	var bits = 0
	for i in range(textures[card.type].size()):
		override_decal(textures[card.type][i], i + 1)
	if Game.is_wall(card.type):
		for i in range(card.wall_flags.size()):
			if card.wall_flags[i]:
				bits |= 1 << i
	elif card.type == Game.TileType.EMPTY:
		bits = randi() % 16
	elif textures.has(card.type):
		bits = 1
	_set_decal_bits(bits)
	
func set_debug_tint(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("debug_tint", v)
	$Plane.get_surface_material(0).set_shader_param("has_debug_tint", true)

func enable_hearts(n):
	for child in $"%HeartContainer".get_children():
		child.visible = false
	for i in range(min(n, $"%HeartContainer".get_child_count())):
		$"%HeartContainer".get_child(i).visible = true
	$Viewport.render_target_update_mode = Viewport.UPDATE_ONCE
		
func play_animation(anim):
	if anim == "scale_up_bridge" || anim == "fade_out_all_to_glass":
		$Plane.get_surface_material(0).shader = glass_card_shader
	$AnimationPlayer.play(anim)
	
var original_bg = preload("res://textures/cards/Card Back.png")

func attach_selection_glow():
	var pass2 = ShaderMaterial.new()
	pass2.shader = selection_glow_shader
	$Plane.get_surface_material(0).next_pass = pass2

func detach_glow():
	$Plane.get_surface_material(0).next_pass = null
	
func set_selection_glow(v):
	$Plane.get_surface_material(0).next_pass.set_shader_param("enable", v)
	
func enable_treasure_glow():
	var pass2 = ShaderMaterial.new()
	pass2.shader = treasure_glow_shader
	$Plane.get_surface_material(0).next_pass = pass2
	
func adjust_treasure_glow(adjust):
	$Plane.get_surface_material(0).next_pass.set_shader_param("glow_adjust", adjust)
	
func override_decal(tex, i):
	$Plane.get_surface_material(0).set_shader_param("decal_%d" % i, tex)

func override_bg(tex):
	if tex == null:
		tex = original_bg
	$Plane.get_surface_material(0).set_shader_param("bg", tex)
	
func _set_header(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("fade_c", v)
	header = v

func _set_header_tint(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("tint", v)
	header_tint = v

func _set_decal_bits(v):
	if $Plane.get_surface_material(0) == null:
		return
		
	$Plane.get_surface_material(0).set_shader_param("decal_bits", v)
	decal_bits = v
	
func _set_decal_scale(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("b_scale", v)
	decal_scale = v
	
func _set_decal_v_offset(v):
	if $Plane.get_surface_material(0) == null:
		return
	$Plane.get_surface_material(0).set_shader_param("v_offset", v)
	decal_v_offset = v
	
func set_text(action_cost, card_name):
	$"%ActionCost".text = str(action_cost)
	$"%CardName".text = str(card_name)
	$Viewport.render_target_update_mode = Viewport.UPDATE_ONCE
	
func _ready():
	$Plane.get_surface_material(0).set_shader_param("label", $Viewport.get_texture())
	$Plane.get_surface_material(0).set_shader_param("has_viewport", true)
