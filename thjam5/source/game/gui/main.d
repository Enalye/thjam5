module game.gui.main;

import atelier;
import game.scene;
import game.menu;

/// Global interface that displays informations and render the world.
final class GameInterface: GuiElement {
    private {
        World _world;
    }

    /// Ctor
    this() {
        size(screenSize);

        _world = new World;
        addChildGui(_world);
    }
}

final class MenuInterface: GuiElement {
    private {
        Music _music;
    }

    this() {
        size(screenSize);
        addChildGui(new Label("Press 'space' to start"));
        _music = fetch!Music("the_idolmaster");
        _music.volume = 0.1f;
        _music.isLooped = true;
        _music.play();
    }

    override void update(float deltaTime) {
        if(getButtonDown(KeyButton.space)) {
            _music.stop();
            onStartGame();
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color.black);
    }
}