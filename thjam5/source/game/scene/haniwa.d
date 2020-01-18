module game.scene.haniwa;

import atelier;
import std.stdio;
import game.scene.actor, game.scene.solid;

class Haniwa: Solid {
    private {
        int   _facing;
        float _speed = 1f;

        enum acceleration = 0.2f;
        enum maxSpeed     = 5f;
    }

    this(Vec2i position_, Vec2i hitbox_, int facing) {
        position = position_;
        hitbox   = hitbox_;  
        _facing  = facing;
    }

    override void update(float deltaTime) {
        _speed = approach(_speed, maxSpeed * _facing, acceleration);
        moveX(_speed);
    }

    /// Render the actor.
    override void draw() {
        drawFilledRect(getHitboxOrigin2d(), getHitboxSize2d(), Color.black);
    }

    /// We touch a wall left or right.
    void onHitWall(CollisionData data) {
        _speed = 0f;
    }
}