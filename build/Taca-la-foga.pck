GDPC                �                                                                         X   res://.godot/exported/133200997/export-0aa9d2fe8ae0b0dda3ba2b5b8f6e3b84-money_parry.scn @      C      ��J�~ay[<a�z���    X   res://.godot/exported/133200997/export-4154c0c6b800685ef6976d3a3b5bf7b5-test_level.scn  �F      �      �)����%� ��s�;�    T   res://.godot/exported/133200997/export-4898101332f2bc915d253738c50657e1-player.scn   7      /      㢟�1zH����GV    d   res://.godot/exported/133200997/export-dc3280bbdb8d03440595e2dcf6037f1c-enemy_navigation_test.scn    A      �      �~S�U�߭��Z��[    X   res://.godot/exported/133200997/export-eaf890459f8e7dfe38714d22ada7f333-test_enemy.scn  �      ,      �:LU3^XU�L5�fθ�    X   res://.godot/exported/133200997/export-f6f79e962f3067c3efe24eb2c54142ef-flamethrower.scn`      �      �vv=b�q�`G�q7    ,   res://.godot/global_script_class_cache.cfg   o            �g�#�;���S�I
Q&    L   res://.godot/imported/backgroud.png-92e969e2926535d5437643c06aa31763.ctex    ?      F      A��]��O�ba�St�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�^      �      �̛�*$q�*�́     T   res://.godot/imported/player-sprite-sheet.png-e4cca13dea92069de9eae4dae4d5482a.ctex 0=      �       <k�ȽB*�����G�    H   res://.godot/imported/tileset.png-4f476bf188ca2a693d61b9bccb73484e.ctex �\            ��^:={��(To^�*       res://.godot/uid_cache.bin   v      �      1�h!0#h�|93��       res://Enemies/enemy.gd  �      '      ��3j2���mBt��    (   res://Enemies/scripts/CharacterBody2D.gd        o      �K���!���� �    (   res://Enemies/test_enemy/test_enemy.gd  p      P      �z�Y�u�<TvC    0   res://Enemies/test_enemy/test_enemy.tscn.remap  pl      g       {�@�^
�@��I       res://icon.svg  @r      �      C��=U���^Qu��U3       res://icon.svg.import   �k      �       �@�p����7�       res://player/Hitbox.gd  P<      �       aɄ4�D���du�    ,   res://player/flamethrower/flamethrower.gd          4      v!���2��-�� [�q    4   res://player/flamethrower/flamethrower.tscn.remap   �l      i       ��l�:���4I���    (   res://player/money parry/money_parry.gd �      D      �Y�D&o��0]�4>    0   res://player/money parry/money_parry.tscn.remap Pm      h       ��zK{�>���j�6�    ,   res://player/player-sprite-sheet.png.import 0>      �       t��Cr�t[DD�瘫        res://player/player/player.gd   �,      �
      ì�܀B,(�.tQ�    (   res://player/player/player.tscn.remap   �m      c       3���S�F�8       res://project.binary�w      �       <�X�!N��yVxe�    $   res://stages/backgroud.png.import   P@      �       �ء�\��|��ƶ�    0   res://stages/enemy_navigation_test.tscn.remap   0n      r       tڙ��0I��]d��    $   res://stages/test_level.tscn.remap  �n      g       ���:�nv4�<��ۚ!        res://stages/tileset.png.import �]      �       ,��/��=z�cT�1Ji            extends CharacterBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(68.0,58.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
 class_name TestEnemy
extends Enemy

@onready var hit_area = $HitArea
@onready var sprite_2d = $HitArea/Sprite2D

func _ready():
	super()
	health = 100
	moneyDrop = 10

func _physics_process(_delta):
	super(_delta)
	if(abs(position.direction_to(target.position).x) > abs(position.direction_to(target.position).y)):
		hit_area.rotation_degrees = -180 if (position.direction_to(target.position).x / abs(position.direction_to(target.position).x)) <= 0 else 0
	else:
		hit_area.rotation_degrees = 90 * (position.direction_to(target.position).y / abs(position.direction_to(target.position).y))
		
	#print_debug(health)
	match current_state:
		ENEMY_STATES.ALIVE:
			pass
		ENEMY_STATES.FOLLOWING:
			hit_area.visible = false
			#hit_area.monitorable = false
		ENEMY_STATES.DEAD:
			pass
		ENEMY_STATES.HURT:
			queue_free()
		ENEMY_STATES.LOAD_ATTACK:
			hit_area.visible = true
			#hit_area.monitorable = true
		ENEMY_STATES.ATTACKING:
			#hit_area.layer
			pass

func _on_timer_timeout():
	current_state = ENEMY_STATES.ATTACKING

func _on_hit_area_body_entered(body):
	if(body is Player):
		body.gethit(dmg)
RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    radius    script    size 	   _bundled       Script '   res://Enemies/test_enemy/test_enemy.gd ��������
   Texture2D    res://icon.svg �',���6      local://CircleShape2D_gb64u �         local://RectangleShape2D_rvuer �         local://PackedScene_d5whe          CircleShape2D             RectangleShape2D       
     pA  �A         PackedScene          	         names "      
   TestEnemy    motion_mode    slide_on_ceiling    wall_min_slide_angle    script    CharacterBody2D    CollisionShape2D    shape 	   Sprite2D 	   rotation    scale    texture    NavigationAgent2D    path_postprocessing    debug_enabled    Timer 
   wait_time 	   one_shot    HitArea    visible    Area2D 	   position 	   modulate    _on_timer_timeout    timeout    _on_hit_area_body_entered    body_entered    	   variants                                                  �I@
     �=  �=               )   �������?
     �A                ��#?���=�� =  �?
     �A���
   ���=  `>      node_count             nodes     ^   ��������       ����                                              ����                           ����   	      
                              ����                                  ����      	                           ����                          ����      
                          ����               
                      conn_count             conns                                                              node_paths              editable_instances              version             RSRC    class_name Enemy
extends CharacterBody2D

@export var health: int = 10
@export var moneyDrop: int = 1
@export var dmg: int = 1
@export var speed: int = 50
var moneyMultiplier: int = 1

enum ENEMY_STATES {ALIVE, FOLLOWING, DEAD, HURT, LOAD_ATTACK, ATTACKING}
var current_state: ENEMY_STATES

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target: Player

@export var sight_range: float = 100
@export var attack_range: float = 30

@onready var timer: Timer = $Timer

func _ready():
	current_state = ENEMY_STATES.ALIVE
	navigation_agent.path_desired_distance = attack_range
	navigation_agent.target_desired_distance = attack_range

func _process(delta):
	match current_state:
		ENEMY_STATES.ALIVE:
			pass
		ENEMY_STATES.FOLLOWING:
			pass
		ENEMY_STATES.DEAD:
			pass
		ENEMY_STATES.HURT:
			pass
		ENEMY_STATES.ATTACKING:
			pass

func _physics_process(delta):
	match current_state:
		ENEMY_STATES.ALIVE:
			if(position.distance_to(target.position) < sight_range):
				current_state = ENEMY_STATES.FOLLOWING
		ENEMY_STATES.FOLLOWING:
			handle_navigation()
		ENEMY_STATES.DEAD:
			pass
		ENEMY_STATES.HURT:
			pass
		ENEMY_STATES.LOAD_ATTACK:
			pass
		ENEMY_STATES.ATTACKING:
			#print("Attack")
			current_state = ENEMY_STATES.FOLLOWING

func handle_navigation() -> void:
	call_deferred("actor_setup")
	if (!navigation_agent.is_navigation_finished()):
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		velocity = current_agent_position.direction_to(next_path_position) * speed
		move_and_slide()
	elif (navigation_agent.is_target_reached()):
		current_state = ENEMY_STATES.LOAD_ATTACK
		timer.start()

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(target.position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func damage(damageTaken: int):
	health = max(health - damageTaken, 0)
	if health == 0:
		current_state = ENEMY_STATES.DEAD
	else:
		current_state = ENEMY_STATES.HURT
         class_name Flamethrower
extends Hitbox

@export var SPEED : float = 2.5
var direction : Vector2

func _ready():
	damage = 1
	knockback = 1
	direction += Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1))

func _physics_process(_delta):
	position += direction*SPEED

func _destroy_timer():
	queue_free()
            RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    radius    script 	   _bundled       Script *   res://player/flamethrower/flamethrower.gd ��������      local://CircleShape2D_qymeo k         local://PackedScene_1d36p �         CircleShape2D            �@         PackedScene          	         names "         Flamethrower    script    Area2D 
   Collision    shape    debug_color    CollisionShape2D    DestroyTimer 
   wait_time 	   one_shot 
   autostart    Timer    enemy_collided    body_entered    _destroy_timer    timeout    	   variants                              ��s?    ��?���>      ?            node_count             nodes     !   ��������       ����                            ����                                 ����         	      
                conn_count             conns                                                               node_paths              editable_instances              version             RSRC     class_name moneyParry
extends Hitbox

func _ready():
	damage = 10
	knockback = 1
	$Particles.emitting = true

func _destroy_timer():
	queue_free()

func enemy_collided(Body):
	if Body is Enemy:
		if Body.isAttacking:
			damage *= 2
			Body.moneyMultiplier = min(Body.moneyMultiplier + 1, 4)
			
		super.enemy_collided(Body)
            RSRC                    PackedScene            ��������                                            T      resource_local_to_scene    resource_name    custom_solver_bias    radius    script    lifetime_randomness    particle_flag_align_y    particle_flag_rotate_y    particle_flag_disable_z "   particle_flag_damping_as_friction    emission_shape_offset    emission_shape_scale    emission_shape 
   angle_min 
   angle_max    angle_curve    inherit_velocity_ratio    velocity_pivot 
   direction    spread 	   flatness    initial_velocity_min    initial_velocity_max    angular_velocity_min    angular_velocity_max    angular_velocity_curve    directional_velocity_curve    orbit_velocity_min    orbit_velocity_max    orbit_velocity_curve    radial_velocity_min    radial_velocity_max    radial_velocity_curve    velocity_limit_curve    gravity    linear_accel_min    linear_accel_max    linear_accel_curve    radial_accel_min    radial_accel_max    radial_accel_curve    tangential_accel_min    tangential_accel_max    tangential_accel_curve    damping_min    damping_max    damping_curve    attractor_interaction_enabled 
   scale_min 
   scale_max    scale_curve    scale_over_velocity_min    scale_over_velocity_max    scale_over_velocity_curve    color    color_ramp    color_initial_ramp    alpha_curve    emission_curve    hue_variation_min    hue_variation_max    hue_variation_curve    anim_speed_min    anim_speed_max    anim_speed_curve    anim_offset_min    anim_offset_max    anim_offset_curve    turbulence_enabled    turbulence_noise_strength    turbulence_noise_scale    turbulence_noise_speed    turbulence_noise_speed_random    turbulence_influence_min    turbulence_influence_max $   turbulence_initial_displacement_min $   turbulence_initial_displacement_max    turbulence_influence_over_life    collision_mode    collision_use_scale    sub_emitter_mode    sub_emitter_keep_velocity    size 	   _bundled       Script (   res://player/money parry/money_parry.gd ��������      local://CircleShape2D_girtk �      &   local://ParticleProcessMaterial_hrose �      #   local://PlaceholderTexture2D_6qoc6 _	         local://PackedScene_smwy5 �	         CircleShape2D            @B         ParticleProcessMaterial                     4C        �B        �B"                           PlaceholderTexture2D    R   
      A   A         PackedScene    S      	         names "         moneyParry    script    Area2D 
   Collision    shape    CollisionShape2D 
   Particles 	   emitting    amount    process_material    texture 	   lifetime 	   one_shot    explosiveness    GPUParticles2D    DestroyTimer 
   autostart    Timer    enemy_collided    body_entered    _destroy_timer    timeout    	   variants    	                                 @                           ?         �?      node_count             nodes     2   ��������       ����                            ����                           ����               	      
                                          ����                         conn_count             conns                                                               node_paths              editable_instances              version             RSRC             class_name Player
extends CharacterBody2D

@onready var flamethrowerResource: Resource = preload("res://player/flamethrower/flamethrower.tscn")
@onready var moneyparryResource: Resource = preload("res://player/money parry/money_parry.tscn")

@export var WALK_SPEED: float = 150
@export var FLAMETHROWER_WALK_SPEED: float = 50
@export var WALK_ACCELERATION: float = 0.2

enum PLAYER_STATES {MOVE, FIRE, CASH, HURT, DEAD}
const HP_MAX: int = 10
var state: PLAYER_STATES = PLAYER_STATES.MOVE
var hp: int = HP_MAX

var inputDirection: Vector2 = Vector2.ZERO
var inputFlamethrower: bool = false
var inputMoneyparry: bool = false
var aimDirection : Vector2 = Vector2.LEFT
var aimTargetDirection : Vector2 = Vector2.LEFT

func _physics_process(_delta):
	get_input()
	
	match state:
		PLAYER_STATES.MOVE:
			velocity = lerp(velocity, WALK_SPEED*inputDirection, WALK_ACCELERATION)
			
			if inputMoneyparry:
				state = PLAYER_STATES.CASH
			elif inputFlamethrower:
				state = PLAYER_STATES.FIRE
				
		PLAYER_STATES.FIRE:
			velocity = lerp(velocity, FLAMETHROWER_WALK_SPEED*inputDirection, WALK_ACCELERATION)
			
			var flamethrowerInstance: Flamethrower = flamethrowerResource.instantiate()
			flamethrowerInstance.position = position
			flamethrowerInstance.direction = aimDirection
			flamethrowerInstance.rotation_degrees = randi_range(0, 360)
			get_tree().current_scene.add_child(flamethrowerInstance)
			
			if !inputFlamethrower:
				state = PLAYER_STATES.MOVE
			
		PLAYER_STATES.CASH:
			#script temporario, é necessario um AnimationPlayer para definir
			#o timing em que a instancia será criada bem como o retorno para o estado "move"
			velocity = Vector2.ZERO#lerp(velocity, Vector2.ZERO, WALK_ACCELERATION)
			
			var moneyparryInstance = moneyparryResource.instantiate()
			add_child(moneyparryInstance)
			
			state = PLAYER_STATES.MOVE
			
		PLAYER_STATES.DEAD:
			velocity = Vector2.ZERO
	
	move_and_slide()

func get_input():
	inputDirection.x = Input.get_axis("left", "right")
	inputDirection.y = Input.get_axis("up","down")
	inputDirection = inputDirection.normalized()
	
	if inputDirection.length() != 0:
		aimTargetDirection = inputDirection
	
	inputFlamethrower = Input.is_action_pressed("flamethrower")
	inputMoneyparry = Input.is_action_just_pressed("cash_parry")
	
	aimDirection = lerp(aimDirection, aimTargetDirection, 0.4)
	$Sprite2D.rotation = aimDirection.angle()

func gethit(damage: int):
	print("ai")
	#state = PLAYER_STATES.HURT
	
	hp = max(hp - damage, 0)
	if hp == 0:
		$DeathResetTimer.start()
		state = PLAYER_STATES.DEAD


func _on_death_reset_timer_timeout():
	get_tree().reload_current_scene()


func _on_area_2d_area_entered(area):
	#print(area)
	pass
            RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    radius    script 	   _bundled       Script    res://player/player/player.gd ��������
   Texture2D %   res://player/player-sprite-sheet.png ��I����m      local://CircleShape2D_i62y1 �         local://PackedScene_rt2ac �         CircleShape2D             A         PackedScene          	         names "         Player    script    CharacterBody2D    Area2D 
   Collision    shape    CollisionShape2D 	   Sprite2D    texture    DeathResetTimer 
   wait_time 	   one_shot    Timer    _on_area_2d_area_entered    area_entered    _on_death_reset_timer_timeout    timeout    	   variants                                          ?            node_count             nodes     6   ��������       ����                            ����                     ����                           ����                           ����                        	   ����   
                      conn_count             conns                                                              node_paths              editable_instances              version             RSRC class_name Hitbox
extends Area2D

@export var damage: int = 0
@export var knockback: float = 0

func enemy_collided(body):
	if body is Enemy:
		body.velocity = knockback*(body.position - position)
		body.damage(damage)
     GST2            ����                        �   RIFF�   WEBPVP8L�   /����$���gr��	()i$I*�fV�җ;��$���_�^%gA����[��pF��k�Ȁ�n"�v��J��B��� !H|U�ηӸ�LA�y|���9D��H "��^N�^-q�y�7^8]�]z����^}��H��xϚ�'����a^ ���7��    [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dk2uhic5ibiyn"
path="res://.godot/imported/player-sprite-sheet.png-e4cca13dea92069de9eae4dae4d5482a.ctex"
metadata={
"vram_texture": false
}
 GST2   �   @      ����               � @          RIFF  WEBPVP8L�   /�  $ S^������IM�l(��(u�X����M��f����H�M�W�6E	p�n�(9��{�#M�4�N�yJ�%�ד�iwL�H^թˎ�Q����9�~��x�Թ!���O��O�����̿gl��3�5��Yﻻ�	���z��4n1��թ�:>\���=�U�7�ո�����jٌ�l��������;
6ZE��Yﻏ�.�g�*c�/�ةc�M�{¶��R���          [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://l3junmc820sc"
path="res://.godot/imported/backgroud.png-92e969e2926535d5437643c06aa31763.ctex"
metadata={
"vram_texture": false
}
            RSRC                    PackedScene            ��������                                                  ..    Player    resource_local_to_scene    resource_name 	   vertices 	   polygons 	   outlines    parsed_geometry_type    parsed_collision_mask    source_geometry_mode    source_geometry_group_name 
   cell_size    agent_radius    script 	   _bundled       PackedScene     res://player/player/player.tscn �X��s2
1   PackedScene )   res://Enemies/test_enemy/test_enemy.tscn $Ao@�'       local://NavigationPolygon_457md P         local://PackedScene_74wvg .         NavigationPolygon       %        zC  C  �@  C  �@  �@  zC  �@                                      %        �@  �@  zC  �@  zC  C  �@  C
   ,       navigation_polygon_source_group                    PackedScene          	         names "   	      EnemyNavigationTest    Node2D    NavigationRegion2D    navigation_polygon    Player 	   position 
   TestEnemy    target    attack_range    	   variants                           
     PB  �B         
     ZC  B                  �A      node_count             nodes     &   ��������       ����                      ����                      ���                           ���                 @                   conn_count              conns               node_paths              editable_instances              version             RSRCRSRC                    PackedScene            ��������                                            Z      ..    Player    resource_local_to_scene    resource_name    texture    margins    separation    texture_region_size    use_texture_padding    0:0/0 &   0:0/0/physics_layer_0/linear_velocity '   0:0/0/physics_layer_0/angular_velocity '   0:0/0/physics_layer_0/polygon_0/points    0:0/0/script    1:0/0 &   1:0/0/physics_layer_0/linear_velocity '   1:0/0/physics_layer_0/angular_velocity '   1:0/0/physics_layer_0/polygon_0/points    1:0/0/script    2:0/0 &   2:0/0/physics_layer_0/linear_velocity '   2:0/0/physics_layer_0/angular_velocity '   2:0/0/physics_layer_0/polygon_0/points    2:0/0/script    0:1/0 &   0:1/0/physics_layer_0/linear_velocity '   0:1/0/physics_layer_0/angular_velocity '   0:1/0/physics_layer_0/polygon_0/points    0:1/0/script    1:1/0 &   1:1/0/physics_layer_0/linear_velocity '   1:1/0/physics_layer_0/angular_velocity '   1:1/0/physics_layer_0/polygon_0/points    1:1/0/script    2:1/0 &   2:1/0/physics_layer_0/linear_velocity '   2:1/0/physics_layer_0/angular_velocity '   2:1/0/physics_layer_0/polygon_0/points    2:1/0/script    0:2/0 &   0:2/0/physics_layer_0/linear_velocity '   0:2/0/physics_layer_0/angular_velocity '   0:2/0/physics_layer_0/polygon_0/points    0:2/0/script    1:2/0 &   1:2/0/physics_layer_0/linear_velocity '   1:2/0/physics_layer_0/angular_velocity '   1:2/0/physics_layer_0/polygon_0/points    1:2/0/script    2:2/0 &   2:2/0/physics_layer_0/linear_velocity '   2:2/0/physics_layer_0/angular_velocity '   2:2/0/physics_layer_0/polygon_0/points    2:2/0/script    0:3/0 &   0:3/0/physics_layer_0/linear_velocity '   0:3/0/physics_layer_0/angular_velocity '   0:3/0/physics_layer_0/polygon_0/points    0:3/0/script    1:3/0 &   1:3/0/physics_layer_0/linear_velocity '   1:3/0/physics_layer_0/angular_velocity '   1:3/0/physics_layer_0/polygon_0/points    1:3/0/script    2:3/0 &   2:3/0/physics_layer_0/linear_velocity '   2:3/0/physics_layer_0/angular_velocity '   2:3/0/physics_layer_0/polygon_0/points    2:3/0/script    script    tile_shape    tile_layout    tile_offset_axis 
   tile_size    uv_clipping     physics_layer_0/collision_layer 
   sources/0    tile_proxies/source_level    tile_proxies/coords_level    tile_proxies/alternative_level 	   vertices 	   polygons 	   outlines    parsed_geometry_type    parsed_collision_mask    source_geometry_mode    source_geometry_group_name 
   cell_size    agent_radius 	   _bundled       PackedScene     res://player/player/player.tscn �X��s2
1   PackedScene )   res://Enemies/test_enemy/test_enemy.tscn $Ao@�'
   Texture2D    res://stages/tileset.png T�B����+   !   local://TileSetAtlasSource_he2m1 P         local://TileSet_hp7yk �          local://NavigationPolygon_w8xdi          local://PackedScene_u27lc �         TileSetAtlasSource >               	          
   
                        %         �   �   A   �   A   A   �   A                   
                        %         �   �   A   �   A   A   �   A                   
                        %         �   �   A   �   A   A   �   A                   
                        %         �   �   A   �   A   A   �   A                   
                         %         �   �   A   �   A   A   �   A!      "          #   
           $          %   %         �   �   A   �   A   A   �   A&      '          (   
           )          *   %         �   �   A   �   A   A   �   A+      ,          -   
           .          /   %         �   �   A   �   A   A   �   A0      1          2   
           3          4   %         �   �   A   �   A   A   �   A5      6          7   
           8          9   %         �   �   A   �   A   A   �   A:      ;          <   
           =          >   %         �   �   A   �   A   A   �   A?      @          A   
           B          C   %         �   �   A   �   A   A   �   AD      E         TileSet    K         L             E         NavigationPolygon    P   %        tC  C  0A  C  0A   A  tC   AQ                             R         %        �?  C  ~C  C  ~C      �?    V   ,       navigation_polygon_source_group E         PackedScene    Y      	         names "      
   TestLevel    Node2D    Player 	   position 
   TestEnemy    target    TileMap 	   tile_set    format    layer_0/tile_data    NavigationRegion2D    navigation_polygon    	   variants    	             
     �B  LB         
     HC  �B                                �                                                                                   	                                
                                                                                                                	         
                                                                                                                                                                                   node_count             nodes     1   ��������       ����                ���                            ���                 @                     ����               	                  
   
   ����                   conn_count              conns               node_paths              editable_instances              version       E      RSRC              GST2   0   @      ����               0 @        �   RIFF�   WEBPVP8L�   //� @�m�"�v�ҐIs�����?X�m$[�J@�*�_B	�#[^�<�|��	������md�9��FY�d[��S:��@S����e��ȁ '�-���H���bfvU ��|�^��y�em�-1�d��<����${��K��9e�j� Wu#ɳ* pU�ϰ��p���8dv /UZ�� [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bkx3pd855ii17"
path="res://.godot/imported/tileset.png-4f476bf188ca2a693d61b9bccb73484e.ctex"
metadata={
"vram_texture": false
}
             GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bwen7puonvdjj"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                [remap]

path="res://.godot/exported/133200997/export-eaf890459f8e7dfe38714d22ada7f333-test_enemy.scn"
         [remap]

path="res://.godot/exported/133200997/export-f6f79e962f3067c3efe24eb2c54142ef-flamethrower.scn"
       [remap]

path="res://.godot/exported/133200997/export-0aa9d2fe8ae0b0dda3ba2b5b8f6e3b84-money_parry.scn"
        [remap]

path="res://.godot/exported/133200997/export-4898101332f2bc915d253738c50657e1-player.scn"
             [remap]

path="res://.godot/exported/133200997/export-dc3280bbdb8d03440595e2dcf6037f1c-enemy_navigation_test.scn"
              [remap]

path="res://.godot/exported/133200997/export-4154c0c6b800685ef6976d3a3b5bf7b5-test_level.scn"
         list=Array[Dictionary]([{
"base": &"CharacterBody2D",
"class": &"Enemy",
"icon": "",
"language": &"GDScript",
"path": "res://Enemies/enemy.gd"
}, {
"base": &"Hitbox",
"class": &"Flamethrower",
"icon": "",
"language": &"GDScript",
"path": "res://player/flamethrower/flamethrower.gd"
}, {
"base": &"Area2D",
"class": &"Hitbox",
"icon": "",
"language": &"GDScript",
"path": "res://player/Hitbox.gd"
}, {
"base": &"CharacterBody2D",
"class": &"Player",
"icon": "",
"language": &"GDScript",
"path": "res://player/player/player.gd"
}, {
"base": &"Enemy",
"class": &"TestEnemy",
"icon": "",
"language": &"GDScript",
"path": "res://Enemies/test_enemy/test_enemy.gd"
}, {
"base": &"Hitbox",
"class": &"moneyParry",
"icon": "",
"language": &"GDScript",
"path": "res://player/money parry/money_parry.gd"
}])
   <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
          
   $Ao@�'(   res://Enemies/test_enemy/test_enemy.tscn��~ۮEp+   res://player/flamethrower/flamethrower.tscn�6�C�Z)   res://player/money parry/money_parry.tscn�X��s2
1   res://player/player/player.tscnV1�X�#.?'   res://stages/enemy_navigation_test.tscn�s��m��.   res://stages/test_level.tscn�',���6   res://icon.svgT�B����+   res://stages/tileset.pngr.5[se�   res://stages/backgroud.png��I����m$   res://player/player-sprite-sheet.png  ECFG      application/config/name         Taca-la-foga   application/run/main_scene$         res://stages/test_level.tscn   application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg  "   display/window/size/viewport_width         #   display/window/size/viewport_height      �      display/window/size/mode            display/window/stretch/mode         viewport   input/right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis       
   axis_value       �?   script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script      
   input/left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis       
   axis_value       ��   script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/up�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       ��   script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script      
   input/down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/flamethrower<              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   Z   	   key_label             unicode    z      echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode       	   key_label             unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   K   	   key_label             unicode    k      echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index          pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script         input/cash_parry�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   X   	   key_label             unicode    x      echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   J   	   key_label             unicode    j      echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script      9   rendering/textures/canvas_textures/default_texture_filter          #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility  