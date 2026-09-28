extends Node2D

var player_speed = 300.0
var player_health = 100.0
var player_is_attacking = false

var enemy_speed = 100.0
var enemy_health = 100.0
var enemy_is_attacking = false

@onready var player = $Player
@onready var enemy = $Enemy

func _ready():
    setup_animations(player, "idle", "res://assets/characters/hero_idle.png")
    setup_animations(player, "run", "res://assets/characters/hero_run.png")
    setup_animations(player, "attack", "res://assets/characters/hero_attack.png")
    
    setup_animations(enemy, "idle", "res://assets/characters/enemy_idle.png")
    setup_animations(enemy, "run", "res://assets/characters/enemy_run.png")
    setup_animations(enemy, "attack", "res://assets/characters/enemy_attack.png")
    
    player.play("idle")
    enemy.play("idle")
    print("Game dimulai!")

func setup_animations(sprite_node, anim_name, texture_path):
    if not sprite_node.sprite_frames:
        sprite_node.sprite_frames = SpriteFrames.new()
    if not sprite_node.sprite_frames.has_animation(anim_name):
        sprite_node.sprite_frames.add_animation(anim_name)
    
    var tex = load(texture_path)
    if not tex:
        print("ERROR: Tidak bisa load: ", texture_path)
        return
    
    var frame_height = tex.get_height()
    var frame_width = frame_height
    var num_frames = int(tex.get_width() / frame_width)
    if num_frames < 1:
        num_frames = 1
        frame_width = tex.get_width()
    
    print("Animasi ", anim_name, ": ", num_frames, " frame")
    sprite_node.sprite_frames.set_animation_speed(anim_name, 8.0)
    sprite_node.sprite_frames.set_animation_loop(anim_name, true)
    
    for i in range(num_frames):
        var atlas = AtlasTexture.new()
        atlas.atlas = tex
        atlas.region = Rect2(i * frame_width, 0, frame_width, frame_height)
        sprite_node.sprite_frames.add_frame(anim_name, atlas)
    
    var target_height = 150.0
    var scale_factor = target_height / frame_height
    sprite_node.scale = Vector2(scale_factor, scale_factor)

func _process(delta):
    var move_dir = 0
    if Input.is_action_pressed("move_right"):
        move_dir = 1
        player.flip_h = false
    elif Input.is_action_pressed("move_left"):
        move_dir = -1
        player.flip_h = true
        
    if move_dir != 0 and not player_is_attacking:
        player.position.x += move_dir * player_speed * delta
        player.play("run")
    elif not player_is_attacking:
        player.play("idle")
            
    if Input.is_action_just_pressed("attack") and not player_is_attacking:
        player_is_attacking = true
        player.play("attack")
        await get_tree().create_timer(0.5).timeout
        player_is_attacking = false

    if not enemy_is_attacking:
        if enemy.position.x > player.position.x + 120:
            enemy.position.x -= enemy_speed * delta
            enemy.flip_h = false
            enemy.play("run")
        elif enemy.position.x < player.position.x - 120:
            enemy.position.x += enemy_speed * delta
            enemy.flip_h = true
            enemy.play("run")
        else:
            enemy.play("idle")
            enemy_is_attacking = true
            enemy.play("attack")
            await get_tree().create_timer(0.6).timeout
            enemy_is_attacking = false

    if player.position.distance_to(enemy.position) < 150:
        if player_is_attacking:
            enemy_health -= 30 * delta
        if enemy_is_attacking:
            player_health -= 20 * delta
        if player_health <= 0 or enemy_health <= 0:
            print("GAME OVER!")
            await get_tree().create_timer(2.0).timeout
            player_health = 100
            enemy_health = 100
            get_tree().reload_current_scene()
