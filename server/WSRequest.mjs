import { decode } from "./protocol.mjs";
import { encode } from "./protocol.mjs";

export class WSRequest {
	constructor(data, ws) {
		this.data = {};
		this.ws = ws;
		this.id = null;
		this.channel = null;
		this.payload = {};
		this.error = false;
		this.action = null;
		try {
			this.data = decode(data);
		} catch (error) {
			this.error = true;
			console.log(`Error decoding request data "${data}"`);
		}
		if ("reqId" in this.data) {
			this.id = this.data.reqId;
		} else {
			this.error = true;
			console.log("Missing reqId");
		}
		if (this.data.action) {
			this.action = this.data.action;
		} else {
			this.error = true;
			console.log("Missing action");
		}
		if (this.data.channel) {
			this.channel = this.data.channel;
		}
		if (this.data.payload) {
			this.payload = this.data.payload;
		}
	}
	send(payload) {
		this.ws.send(
			encode({
				reqId: this.id,
				channel: this.channel,
				payload,
			})
		);
	}
	throw(message) {
		this.ws.send(
			encode({
				reqId: this.id,
				channel: this.channel,
				error: message.toString(),
			})
		);
	}
}
