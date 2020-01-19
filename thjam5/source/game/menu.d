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
	setWindowClearColor(Color.black);

	const string iconPath = buildNormalizedPath("assets", "media", "gui", "logo.png");
	if(exists(iconPath))
		setWindowIcon(iconPath);

	onStartupLoad(&onLoadComplete);

	runApplication();
	destroyApplication();
}


private void onLoadComplete() {
    setDefaultFont(fetch!TrueTypeFont("Cascadia"));
	onMainMenu();
}

void onMainMenu() {
	removeRootGuis();
	addRootGui(new MenuInterface);
}

void onStartGame() {
	removeRootGuis();
	addRootGui(new GameInterface);
}