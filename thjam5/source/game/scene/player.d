module game.scene.player;

import atelier;
import game.scene.actor;

/// Player controlled actor.
final class Player: Actor {
    private {
    }

    /// Ctor
    this() {
        position = Vec2i(0, 0);
        hitbox = Vec2i(16, 32);
    }

    override void update(float deltaTime) {
        if(isButtonDown(KeyButton.a)) {
            moveX(-5f * deltaTime, null);
        }

        if(isButtonDown(KeyButton.d)) {
            moveX(5f * deltaTime, null);
        }

        if(isButtonDown(KeyButton.w)) {
            moveY(5f * deltaTime, null);
        }

        if(isButtonDown(KeyButton.s)) {
            moveY(-5f * deltaTime, null);
        }
    }

    override void draw() {
    }

    override void squish() {
        import std.stdio;
        writeln("squished");
    }
}