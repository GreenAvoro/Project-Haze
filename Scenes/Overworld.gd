extends Node2D

var time = 8
var day = 1
export var time_speed = 0.25

const NPC_SCENE = preload("res://Scenes/NPC.tscn")
const spawn_script = spawn_script.spawn_script

func _process(delta):
	
	time += delta * time_speed
	if time >= 24:
		time = 0
		day += 1
	time_day()
	
	if !spawn_script.empty():
		if day == spawn_script[0].day and int(time) == spawn_script[0].time:
			var npc = NPC_SCENE.instance()
			npc.char_name = spawn_script[0].name
			var sprites = spawn_script[0].sprites
			npc.get_node("AnimatedSprite").frames = sprites
			spawn_script.pop_front()
			npc.position.x = 340
			
			if $Player.position.y > 78:
				npc.position.y = -180
			else:
				npc.position.y = 300
			add_child(npc)
			npc.target_global_pos = $"Assembly Point".position
			npc.moving = true

func time_day():
	var new_time = (time-(pow(time,2)/24))/6
	if new_time < 0.2:
		return
	var color = Color(new_time, new_time, new_time, 1)
	$Ambience.set_color(color)


func _on_Button_pressed():
	get_tree().quit()
