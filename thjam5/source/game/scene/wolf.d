module game.scene.wolf;

import atelier;
import game.scene.enemy;

class Wolf: Enemy {
    private {
        Sprite _idleSprite;
        Sprite _jumpSprite;
        Sprite _currentSprite;
    }

    this(Vec2i pos) {
        super(pos);
        _idleSprite    = fetch!Sprite("wolf.black.idle");
        _jumpSprite    = fetch!Sprite("wolf.black.jump");
        _currentSprite = _idleSprite;
    }

    override void update(float deltaTime) {    
        hitbox = Vec2i(cast(int)(_currentSprite.size.x / 2f), cast(int)(_currentSprite.size.y / 2f));
        super.update(deltaTime);
    }

    override void draw() {
        drawFilledRect(getHitboxOrigin2d(), getHitboxSize2d(), Color.red);
        _idleSprite.draw(getPosition2d());
    }
}