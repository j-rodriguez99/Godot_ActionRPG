import { WSRequest } from "./WSRequest.mjs";
import { WebSocketServer } from "ws";
import { channels } from "./channels.mjs";

const wss = new WebSocketServer({ port: 8080 });

const handlers = {
	join_channel({ channel }, ws) {
		if (!channels.has(channel)) {
			throw new Error(`Invalid channel "${channel}"`);
		}
		const c = channels.get(channel);
		if (c.locked) {
			throw new Error(`"${channel}" is a locked channel`);
		}
		const { id } = c.registerPlayer(ws);
		return { id };
	},
};

const handleMessage = (ws) => (data) => {
	console.log("handleMessage", data.toString());
	const req = new WSRequest(data, ws);
	if (req.error) {
		return;
	}
	if (!req.id) {
		req.throw("Missing reqId");
		return;
	}
	if (!req.action) {
		req.throw("Missing action");
		return;
	}
	if (req.channel) {
		if (!channels.has(req.channel)) {
			req.throw(`Invalid channel "${channel}"`);
		}
		const c = channels.get(req.channel);
		try {
			const payload = c.handleMessage(req.action, req.payload, ws);
			req.send(payload);
		} catch (error) {
			console.log(error);
			req.throw(error.message);
		}
	} else {
		if (!handlers[req.action]) {
			req.throw("Invalid action");
			return;
		}
		try {
			const payload = handlers[req.action](req.payload, ws);
			req.send(payload);
		} catch (error) {
			console.log(error);
			req.throw(error.message);
		}
	}
};

wss.on("connection", function connection(ws) {
	console.log("connection");
	ws.on("message", handleMessage(ws));
});
