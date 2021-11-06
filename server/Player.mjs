import { encode } from "./protocol.mjs";
export class Player {
    constructor({ id, ws }) {
        this.id = id;
        this.ws = ws;
    }
    send(data) {
        this.ws.send(encode(data));
    }
}