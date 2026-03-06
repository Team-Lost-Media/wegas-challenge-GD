@tool
extends RichTextEffectBase
## "Censors" a word by replacing vowels with symbols.

## Syntax: [cuss][]
const bbcode = "cuss"

const VOWELS := "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
const CUSS_CHARS := "&$!@*#%"
const IGNORE := "!?.,;\""

var chance: int = 10

func _process_custom_fx(c: CharFXTransform):
	# Always censor vowels.
	if get_char(c) in VOWELS and randi_range(1, chance) != 1:
		set_char(c, CUSS_CHARS[int(rand_anim(c, 1.0, len(CUSS_CHARS)))])
		#c.color = Color.RED
	return true
