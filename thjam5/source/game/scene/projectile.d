module game.scene.projectile;

import atelier;
import game.scene.solid;
import game.scene.actor : CollisionData;
import game.scene.world;

alias Action = void delegate(CollisionData);
alias ProjectileArray = IndexedArray!(Projectile, 5000u);

/// Basic wall, do nothing.
class Projectile {
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
    final void move(Vec2f direction, Action onCollide) {

		const auto len = direction.length;
		const auto scale = _hitbox.length;

		if(len<scale)
		{
			moveX(direction.x, onCollide);
			moveY(direction.y, onCollide);
		}
		else
		{
			auto rescale = direction/scale;
			auto steps = len/scale - 1;
			moveX(rescale.x/2, onCollide);
			moveY(rescale.y/2, onCollide);
			while(steps != 0)
			{
				moveX(rescale.x, onCollide);
				moveY(rescale.y, onCollide);
				steps--;
			}
			moveX(rescale.x/2, onCollide);
			moveY(rescale.y/2, onCollide);
		}
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

    void update(float deltaTime) {
    }

    void draw() {
        drawFilledRect(getHitboxOrigin2d(), getHitboxSize2d(), Color.pink);
    }
}