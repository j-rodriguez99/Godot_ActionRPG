import { Channel } from "../Channel.mjs";
export class Game extends Channel {
	constructor(options) {
		super({ ...options });
		this.actionHandlers = {
			join_game() {},
		};
	}
}
