import std.stdio, std.exception;

import game.menu;

void main(string[] args) {
	try {
		startGame(args);
	}
	catch(Exception e) {
		writeln(e.msg);
		foreach(trace; e.info) {
			writeln("at: ", trace);
		}
	}
}
