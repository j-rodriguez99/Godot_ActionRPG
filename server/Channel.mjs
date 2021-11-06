import { Player } from "./Player.mjs";

export class Channel {
	constructor({ id, maxPlayers, locked }) {
		this.players = new Map();
		this.maxPlayers = maxPlayers;
		this.handlers = {};
		this.locked = locked;
		this.id = id;
	}
	registerPlayer(ws) {
		if (this.players.size >= this.maxPlayers) {
			throw new Error("Channel is full");
		}
		let id;
		for (id = 0; id < this.maxPlayers; id++) {
			if (!this.players.has(id)) {
				break;
			}
		}
		const player = new Player({ id, ws });
		this.players.set(id, player);
		ws.on("close", () => {
			this.unregisterPlayer(id);
		});
		this.broadcast("set_players", { players: this.playerList() });
		return player;
	}
	unregisterPlayer(id) {
		console.log(`Player ${id} left the channel`);
		this.players.delete(id);
	}
	broadcast(action, payload, excludeIds = []) {
		this.players.forEach((p) => {
			if (!excludeIds.includes(p.id)) {
				p.send({
					action,
					channel: this.id,
					payload,
				});
			}
		});
	}
	handleMessage(action, payload, ws) {
		if (!this.handlers[action]) {
			throw new Error(`Invalid action "${action}"`);
		}
		return this.handlers[action](payload, ws);
	}
	playerList() {
		return Array.from(this.players).map((p) => ({ id: p[0] }));
	}
}
