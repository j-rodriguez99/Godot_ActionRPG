extends Node

class_name WSRequest

var _client
var _reqIds = {}

signal response()

func setClient(client):
	_client = client
	_client.connect("data_received", self, "_on_data")

func getNextId():
	var id = 1
	while(_reqIds.has(id)):
		id += 1
	_reqIds[id] = 1
	return id

func send(action, payload=null, channel=null):
	var data = {
		"action": action
	}
	if payload != null:
		data["payload"] = payload
	if channel!= null:
		data["channel"] = channel
	data["reqId"] = getNextId()
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())
	var done = false
	var res
	while !done:
		res = yield(self, "response")
		done = res.reqId == data["reqId"]
	_reqIds.erase(data["reqId"])
	return res

func _on_data():
	var data = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8())
	if "reqId" in data.result:
		emit_signal("response", data.result)
