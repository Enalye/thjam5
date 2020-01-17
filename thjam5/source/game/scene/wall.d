module game.scene.wall;

import atelier;
import game.scene.solid;

final class Wall: Solid {
    this() {
        position = Vec2i(50, 50);
        hitbox = Vec2i(40, 10);
    }

    override void update(float deltaTime) {

        if(isButtonDown(KeyButton.left))
            moveX(-5f * deltaTime);

        if(isButtonDown(KeyButton.right))
            moveX(5f * deltaTime);

        if(isButtonDown(KeyButton.up))
            moveY(5f * deltaTime);

        if(isButtonDown(KeyButton.down))
            moveY(-5f * deltaTime);
    }

    override void draw() {
        //drawFilledRect(cast(Vec2f) box2d.xy, cast(Vec2f) size2d, Color.green);
    }
}