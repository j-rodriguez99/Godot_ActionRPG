import { Game } from "./channels/Game.mjs";
import { Lobby } from "./channels/Lobby.mjs";
export const channels = new Map();
channels.set("lobby", new Lobby({ id: "lobby", maxPlayers: 256 }));
channels.set(
	"game/209ddd9b-0560-4acf-935a-b77235fd019c",
	new Game({
		id: "game/209ddd9b-0560-4acf-935a-b77235fd019c",
		maxPlayers: 256,
	})
);
