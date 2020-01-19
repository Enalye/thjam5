module game.scene.wolf;

import atelier;
import game.scene.enemy;

class Wolf: Enemy {
    private {
        Sprite _idleSprite;
        Sprite _jumpSprite;
    }

    this(Vec2i pos) {
        super(pos);
        hitbox      = Vec2i(40, 40);
        _idleSprite = fetch!Sprite("wolf.black.idle");
        _jumpSprite = fetch!Sprite("wolf.black.jump");
    }

    override void update(float deltaTime) {
        super.update(deltaTime);
    }

    override void draw() {
        drawFilledRect(getHitboxOrigin2d(), getHitboxSize2d(), Color.red);
        _idleSprite.draw(getPosition2d());
    }
}