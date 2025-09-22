extends RefCounted
class_name ICMessage

# I still dunno what "MS" even stands for
const HEADER = "MS"

var desk_mod: int
var preanim: String
var character: String
var emote: String
var message: String
var side: String
var sfx_name: String
var emote_modifier: int
var char_id: int
var sfx_delay: int
var shout_modifier: int
var evidence: int
var flip: int
var realization: int
var text_color: int
var showname: String
var other_charid: int
var other_name: String
var other_emote: String
var self_offset: String
var other_offset: String
var other_flip: int
var noninterrupting_preanim: int
var sfx_looping: int
var screenshake: int
var frames_shake: int
var frames_realization: int
var frames_sfx: int
var additive: int
var effect: String
var blips: String

static func from_packet(packet: AOPacket) -> ICMessage:
	if packet.header != "MS":
		push_error("ICMessage from_packet: wrong header! (%s)" % packet.header)
	return ICMessage.new(packet.contents)

func _init(...params: Array) -> void:
	if params.size() < 31:
		params.resize(31)
	desk_mod = int(params[0])
	preanim = String(params[1])
	character = String(params[2])
	emote = String(params[3])
	message = String(params[4])
	side = String(params[5])
	sfx_name = String(params[6])
	emote_modifier = int(params[7])
	char_id = int(params[8])
	sfx_delay = int(params[9])
	shout_modifier = int(params[10])
	evidence = int(params[11])
	flip = int(params[12])
	realization = int(params[13])
	text_color = int(params[14])
	showname = String(params[15])
	other_charid = int(params[16])
	other_name = String(params[17])
	other_emote = String(params[18])
	self_offset = String(params[19])
	other_offset = String(params[20])
	other_flip = int(params[21])
	noninterrupting_preanim = int(params[22])
	sfx_looping = int(params[23])
	screenshake = int(params[24])
	frames_shake = int(params[25])
	frames_realization = int(params[26])
	frames_sfx = int(params[27])
	additive = int(params[28])
	effect = String(params[29])
	blips = String(params[30])

## Turns the IC Message into a Packet
func get_packet() -> AOPacket:
	var contents: PackedStringArray = [
		desk_mod,
		preanim,
		character,
		emote,
		message,
		side,
		sfx_name,
		emote_modifier,
		char_id,
		sfx_delay,
		shout_modifier,
		evidence,
		flip,
		realization,
		text_color,
		showname,
		other_charid,
		other_name,
		other_emote,
		self_offset,
		other_offset,
		other_flip,
		noninterrupting_preanim,
		sfx_looping,
		screenshake,
		frames_shake,
		frames_realization,
		frames_sfx,
		additive,
		effect,
		blips,
	]
	return AOPacket.new(HEADER, contents)
