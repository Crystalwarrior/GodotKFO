extends RefCounted
class_name ICMessage

# I still dunno what "MS" even stands for
const HEADER = "MS"

# Local variables of each IC Message property
var desk_mod: int = 0
var pre_emote: String = ""
var char_name: String = ""
var emote: String = ""
var message: String = ""
var side: String = "wit"
var sfx_name: String = ""
var emote_mod: int = 0
var char_id: int = -1
var sfx_delay: int = 0
var objection_mod: String = "0"
var evidence_id: int = 0
var flip: int = 0
var realization: int = 0
var text_color: int = 0
var showname: String = ""
var other_charid: int = -1
var other_name: String = ""
var other_emote: String = ""
var self_offset: String = "0&0"
var other_offset: String = ""
var other_flip: int = 0
var immediate: int = 0
var looping_sfx: int = 0
var screenshake: int = 0
var frame_screenshake: String = ""
var frame_realization: String = ""
var frame_sfx: String = ""
var additive: int = 0
var effect: String = "||"
var third_charid: int = -1
var third_name: String = ""
var third_emote: String = ""
var third_offset: String = "0"
var third_flip: int = 0
var video: String = ""

# Static dictionary to represent each of the IC Message property types. Order matters!
## This is what we receive from the server
static var CHAT_MESSAGE_INBOUND: PackedStringArray = [
	"desk_mod",					# 0
	"pre_emote",				# 1
	"char_name",				# 2
	"emote",					# 3
	"message",					# 4
	"side",						# 5
	"sfx_name",					# 6
	"emote_mod",				# 7
	"char_id",					# 8
	"sfx_delay",				# 9
	"objection_mod",			# 10
	"evidence_id",				# 11
	"flip",						# 12
	"realization",				# 13
	"text_color",				# 14
	"showname",					# 15
	"other_charid",				# 16
	"other_name",				# 17
	"other_emote",				# 18
	"self_offset",				# 19
	"other_offset",				# 20
	"other_flip",				# 21
	"immediate",				# 22
	"looping_sfx",				# 23
	"screenshake",				# 24
	"frame_screenshake",		# 25
	"frame_realization",		# 26
	"frame_sfx",				# 27
	"additive",					# 28
	"effect",					# 29
	"third_charid",				# 30
	"third_name",				# 31
	"third_emote",				# 32
	"third_offset",				# 33
	"third_flip",				# 34
	"video",					# 35
]

## This is what we send to the server
static var CHAT_MESSAGE_OUTBOUND: PackedStringArray = [
	"desk_mod",					# 0
	"pre_emote",				# 1
	"char_name",				# 2
	"emote",					# 3
	"message",					# 4
	"side",						# 5
	"sfx_name",					# 6
	"emote_mod",				# 7
	"char_id",					# 8
	"sfx_delay",				# 9
	"objection_mod",			# 10
	"evidence_id",				# 11
	"flip",						# 12
	"realization",				# 13
	"text_color",				# 14
	"showname",					# 15
	"other_charid",				# 16
	"self_offset",				# 17
	"immediate",				# 18
	"looping_sfx",				# 19
	"screenshake",				# 20
	"frame_screenshake",		# 21
	"frame_realization",		# 22
	"frame_sfx",				# 23
	"additive",					# 24
	"effect",					# 25
	"third_charid",				# 26
	"video",					# 27
]

## Create an ICMessage from inbound property list
static func new_inbound(params: Array) -> ICMessage:
	var ic_message = ICMessage.new()

	# Since the property list is actually gargantuan, let's do some smart initializiation for future-proofing.
	var properties_size = CHAT_MESSAGE_INBOUND.size()
	if params.size() < properties_size:
		params.resize(properties_size)
	for i in properties_size:
		var property_key = CHAT_MESSAGE_INBOUND[i]
		var value = params[i]
		# Do not set null values so we don't over ride the defaults
		if value != null:
			ic_message.set(property_key, value)

	return ic_message

## Create an ICMessage from outbound property list
static func new_outbound(params: Array) -> ICMessage:
	var ic_message = ICMessage.new()

	# Since the property list is actually gargantuan, let's do some smart initializiation for future-proofing.
	var properties_size = CHAT_MESSAGE_OUTBOUND.size()
	if params.size() < properties_size:
		params.resize(properties_size)
	for i in properties_size:
		var property_key = CHAT_MESSAGE_OUTBOUND[i]
		var value = params[i]
		# Do not set null values so we don't over ride the defaults
		if value != null:
			ic_message.set(property_key, value)

	return ic_message

## Turns the IC Message into an Inbound Packet (received by us)
func get_inbound_packet() -> AOPacket:
	var contents: PackedStringArray
	# Get all the correct values
	for key in CHAT_MESSAGE_INBOUND:
		contents.append(self.get(key))
	return AOPacket.new(HEADER, contents)

## Turns the IC Message into an Outbound Packet (sent by us)
func get_outbound_packet() -> AOPacket:
	var contents: PackedStringArray
	# Get all the correct values
	for key in CHAT_MESSAGE_OUTBOUND:
		contents.append(self.get(key))
	return AOPacket.new(HEADER, contents)
