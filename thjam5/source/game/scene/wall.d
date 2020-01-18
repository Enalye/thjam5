module game.scene.wall;

import atelier;
import game.scene.solid;

/// Basic wall, do nothing.
class Wall: Solid {
    /// Ctor
    this(Vec2i position_, Vec2i hitbox_) {
        position = position_;
        hitbox = hitbox_;
    }

    override void update(float deltaTime) {
    }

    override void draw() {
        drawFilledRect(getHitboxOrigin2d(), getHitboxSize2d(), Color.maroon);
    }
}