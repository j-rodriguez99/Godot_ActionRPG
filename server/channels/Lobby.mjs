import { Channel } from "../Channel.mjs";
import { Game } from "./Game.mjs";
import { channels } from "../channels.mjs";
import { v4 as uuidv4 } from "uuid";
export class Lobby extends Channel {
	constructor(options) {
		super(options);
		this.games = new Map();
		this.actionHandlers = {
			create_game(payload, ws) {
				const id = `game/${uuidv4()}`;
				const game = new Game({ id, maxPlayers: 256 });
				game.registerPlayer(ws);
				channels.set(id, game);
				return { id };
			},
			list_games(payload, ws) {},
		};
	}
}
