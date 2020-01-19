module game.scene.wolf;

import atelier;
import game.scene.enemy;

class Wolf: Enemy {
    private {
        Animation _idleAnimation;
        Animation _jumpAnimation;
    }

    this(Vec2i pos) {
        super(pos);
    }
}