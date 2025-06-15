extends AudioStreamPlayer


func play_style_sfx(rank = 0, no_p_style = false) -> void: ##Plays style sounds, based off of the "rank", going from 1 (worst) to 6 (best). Any other rank inputs will play deltarune-explosion.mp3. If no input has been given, it will calculate the style based off of recent events.
	if rank == 0:
		if Global.style_number < 200:
			rank = 1
		elif Global.style_number < 400:
			rank = 2
		elif Global.style_number < 600:
			rank = 3
		elif Global.style_number < 800:
			rank = 4
		elif Global.style_number < 1000:
			rank = 5
		elif no_p_style == false:
			rank = 6
		else:
			rank = 5
	match rank:
		1:
			stream = load("res://assets/SFX/STYLE/rank_d.mp3")
		2:
			stream = load("res://assets/SFX/STYLE/rank_c.mp3")
		3:
			stream = load("res://assets/SFX/STYLE/rank_b.mp3")
		4:
			stream = load("res://assets/SFX/STYLE/rank_a.mp3")
		5:
			stream = load("res://assets/SFX/STYLE/rank_s.mp3")
		6:
			stream = load("res://assets/SFX/STYLE/rank_p.mp3")
		_:
			stream = load("res://assets/SFX/deltarune-explosion.mp3")
	play()
