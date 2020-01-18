module game.scene.actor;

import std.math, std.algorithm.comparison;;
import atelier;
import game.scene.world, game.scene.solid;

alias ActorArray = IndexedArray!(Actor, 5000u);
alias Action = void delegate(CollisionData);

/// Collision information
struct CollisionData {
    /// What the actor hit.
    Solid solid;
    /// Direction the actor was going to.
    Vec2i direction;
}

/// Linear interpolation to approach a point
float approach(float value, float target, float step) {
    return value > target ? max(value - step, target) : min(value + step, target);
}

/// Any physical object.
abstract class Actor {
    private {
        Vec2f _moveRemaining = Vec2f.zero;
        Vec2i _position = Vec2i.zero, _hitbox = Vec2i.zero;
    }

    @property {
        /// Left (x-axis) bound of the actor's hitbox.
        int left() const { return _position.x - _hitbox.x; }
        /// Right (x-axis) bound of the actor's hitbox.
        int right() const { return _position.x + _hitbox.x; }

        /// Down (y-axis) bound of the actor's hitbox.
        int down() const { return _position.y - _hitbox.y; }
        /// Up (y-axis) bound of the actor's hitbox.
        int up() const { return _position.y + _hitbox.y; }

        /// Integer locked physical position.
        Vec2i position() const { return _position; }
        /// Ditto
        Vec2i position(Vec2i v) { return _position = v; }

        /// Integer locked physical bounds.
        Vec2i hitbox() const { return _hitbox; }
        /// Ditto
        Vec2i hitbox(Vec2i v) { return _hitbox = v; }
    }

    /// 2d-space position.
    Vec2f getPosition2d() const {
        return Vec2f(_position.x, -_position.y);
    }

    /// 2d-space size.
    Vec2f getHitboxSize2d() const {
        return Vec2f(_hitbox.x, _hitbox.y) * 2f;
    }

    /// 2d-space top-left corner.
    Vec2f getHitboxOrigin2d() const {
        return Vec2f(
            _position.x - _hitbox.x,
            -_position.y - _hitbox.y);
    }

    /// Move on the horizontal axis.
    final void moveX(float x, Action onCollide) {
        _moveRemaining.x += x;
        int move = cast(int) round(_moveRemaining.x);

        if(move != 0) {
            _moveRemaining.x -= x;
            int dir = move > 0 ? 1 : -1;

            while(move) {
                Solid solid = collideAt(_position + Vec2i(dir, 0), _hitbox);
                if(solid) {
                    if(onCollide) {
                        CollisionData data;
                        data.solid = solid;
                        data.direction = Vec2i(dir, 0);
                        onCollide(data);
                    }
                    break;
                }
                else {
                    _position.x += dir;
                    move -= dir;
                }
            }
        }
    }

    /// Move on the vertical axis.
    final void moveY(float y, Action onCollide) {
        _moveRemaining.y += y;
        int move = cast(int) round(_moveRemaining.y);

        if(move != 0) {
            _moveRemaining.y -= y;
            int dir = move > 0 ? 1 : -1;

            while(move) {
                Solid solid = collideAt(_position + Vec2i(0, dir), _hitbox);
                if(solid) {
                    if(onCollide) {
                        CollisionData data;
                        data.solid = solid;
                        data.direction = Vec2i(0, dir);
                        onCollide(data);
                    }
                    break;
                }
                else {
                    _position.y += dir;
                    move -= dir;
                }
            }
        }
    }

    /// Is the actor riding this solid ?
    bool isRiding(Solid solid) {
        return (solid.left < right) && (solid.up < up) &&
            (solid.right > left) && ((solid.up + 1) > down);
    }

    bool toDelete = false;

    /// Actor logic.
    abstract void update(float deltaTime);
    /// Render the actor.
    abstract void draw();
    /// When squished between solids.
    abstract void squish(CollisionData data);

    /// Display the collider of the actor.
    final void drawHitbox() {
        drawRect(
            getHitboxOrigin2d(),
            getHitboxSize2d(),
            Color.white);
    }

    /// Returns the sign of value (positive = 1, negative = -1, none = 0)
    int sign(float value) {
        return value > 0f ? 1 : (value < 0f ? -1 : 0);
    }
}