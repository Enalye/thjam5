module game.scene.wall;

import atelier;
import game.scene.solid;

/// Basic wall, do nothing.
class Wall: Solid {
    Sprite sprite;

    /// Ctor
    this(string fileName, Vec2i position_, Vec2i hitbox_) {
        sprite   = fetch!Sprite(fileName);
        position = position_;
        hitbox   = hitbox_;
    }

    override void update(float deltaTime) {
    }

    override void draw() {
        sprite.size = getHitboxSize2d();
        sprite.draw(getPosition2d());
    }
}