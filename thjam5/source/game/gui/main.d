module game.gui.main;

import atelier;
import game.scene;

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