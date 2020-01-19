
module game.scene.background;

import atelier;

class Background {
    Sprite _sprite;

    this(string fileName) {
        _sprite = fetch!Sprite(fileName);
    }

    void draw() {
        _sprite.draw(Vec2f.zero);
    }
}