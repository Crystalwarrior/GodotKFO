extends RefCounted
class_name AOPacket

var header: String
var contents: PackedStringArray

var encoding_keys: Dictionary = {
	"#": "<num>",
	"%": "<percent>",
	"$": "<dollar>",
	"&": "<and>"
}

static func from_string(packet_string: String) -> AOPacket:
	var constructed_contents: PackedStringArray
	# If content ends with #, chop it off
	if packet_string.ends_with("#"):
		packet_string = packet_string.left(-1)
	# Split contents of the packet data
	constructed_contents = packet_string.split("#")
	if constructed_contents.is_empty():
		# Can't create a packet from nothing
		return null
	# Grab the header of the packet
	var constructed_header = constructed_contents.get(0)
	# Remove header from contents
	constructed_contents.remove_at(0)
	# Construct an AOPacket to be read and interpreted
	var packet: AOPacket = AOPacket.new(constructed_header, constructed_contents)
	return packet

func _init(_header: String = "", _contents: PackedStringArray = []) -> void:
	header = _header
	contents = _contents

func get_packet_string(encoded: bool = false):
	var _contents: PackedStringArray = contents.duplicate()
	if encoded:
		escape(_contents)
	if _contents.is_empty():
		# Our packet is just the header by itself
		return header + "#%"
	return header + "#" + "#".join(_contents) + "#%";

func net_encode():
	contents = escape(contents)

func net_decode():
	contents = unescape(contents)

func escape(_contents: PackedStringArray):
	var return_contents: PackedStringArray
	for data in _contents:
		for key in encoding_keys:
			var value = encoding_keys[key]
			data = data.replace(key, value)
		return_contents.append(data)
	return return_contents

func unescape(_contents: PackedStringArray):
	var return_contents: PackedStringArray
	for data in _contents:
		for key in encoding_keys:
			var value = encoding_keys[key]
			data = data.replace(value, key)
		return_contents.append(data)
	return return_contents
