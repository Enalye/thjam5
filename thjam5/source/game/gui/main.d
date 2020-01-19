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
        Sprite _bgSprite;
        Animation _spaceAnim;
        Music _music;
    }

    this() {
        size(screenSize);
        _music = fetch!Music("the_idolmaster");
        _music.volume = 0.1f;
        _music.isLooped = true;
        _music.play();

        _bgSprite = fetch!Sprite("ui.bg");
        _spaceAnim = fetch!Animation("ui.space");
    }

    override void update(float deltaTime) {
        if(getButtonDown(KeyButton.space)) {
            _music.stop();
            onStartGame();
        }
        _spaceAnim.update(deltaTime);
    }

    override void draw() {
        _bgSprite.draw(center);
        _spaceAnim.draw(Vec2f(center.x, origin.y + size.y - 100f));
    }
}