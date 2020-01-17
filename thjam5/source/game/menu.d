module game.menu;

import std.file: exists;
import std.path: buildNormalizedPath;
import atelier;
import game.loader, game.gui;

/// Game startup
void startGame(string[] args) {
	createApplication(Vec2u(1280u, 720u), "thjam5");

	setWindowMinSize(Vec2u(1280u, 720u));
	setWindowMaxSize(Vec2u(1280u, 720u));
	setWindowClearColor(Color.white);

	const string iconPath = buildNormalizedPath("assets", "media", "gui", "logo.png");
	if(exists(iconPath))
		setWindowIcon(iconPath);

	onStartupLoad(&onLoadComplete);

	runApplication();
	destroyApplication();
}

private {
	GameInterface _gameInterface;
}

private void onLoadComplete() {
    setDefaultFont(fetch!TrueTypeFont("Cascadia"));
	_gameInterface = new GameInterface;
	onMainMenu();
}

private void onMainMenu() {
	removeRootGuis();
	addRootGui(_gameInterface);
}