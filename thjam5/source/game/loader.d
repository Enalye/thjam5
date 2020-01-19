module game.loader;

import std.path, std.file, std.conv;
import atelier;

private {
    alias OnLoadCompleteCallback = void function();
}

void onStartupLoad(OnLoadCompleteCallback callback) {
    addRootGui(new LoaderGui(callback));
}

import std.stdio: writeln, write;
import std.datetime;
import std.conv: to;

/// Loads all assets on startup.
class LoaderGui: GuiElement {
    private {
        OnLoadCompleteCallback _callback;
    }

    /// Create the loader, the callback is called when finished.
    this(OnLoadCompleteCallback callback) {
        _callback = callback;
        loadTextures();
        loadFonts();
        loadSound();
        loadBgm();
        //Load completed
        removeRootGuis();
        callback();
    }

    override void update(float deltaTime) {

    }

    override void draw() {

    }
}

void loadTextures() {
    auto textureCache = new ResourceCache!Texture;
    auto spriteCache = new ResourceCache!Sprite;
    auto tilesetCache = new ResourceCache!Tileset;
    auto animationCache = new ResourceCache!Animation;
    auto ninePathCache = new ResourceCache!NinePatch;

    setResourceCache!Texture(textureCache);
    setResourceCache!Sprite(spriteCache);
    setResourceCache!Tileset(tilesetCache);
    setResourceCache!Animation(animationCache);
    setResourceCache!NinePatch(ninePathCache);

    Flip getFlip(JSONValue node) {
        switch(getJsonStr(node, "flip", "none")) {
        case "none":
            return Flip.none;
        case "horizontal":
            return Flip.horizontal;
        case "vertical":
            return Flip.vertical;
        case "both":
            return Flip.both;
        default:
            return Flip.none;
        }
    }

    Vec4i getClip(JSONValue node) {
        auto clipNode = getJson(node, "clip");
        Vec4i clip;
        clip.x = getJsonInt(clipNode, "x", 0);
        clip.y = getJsonInt(clipNode, "y", 0);
        clip.z = getJsonInt(clipNode, "w", 1);
        clip.w = getJsonInt(clipNode, "h", 1);
        return clip;
    }

    Vec2i getMargin(JSONValue node) {
        if(hasJson(node, "margin")) {
            auto marginNode = getJson(node, "margin");
            Vec2i margin;
            margin.x = getJsonInt(marginNode, "x", 0);
            margin.y = getJsonInt(marginNode, "y", 0);
            return margin;
        }
        return Vec2i.zero;
    }

    EasingAlgorithm getEasing(JSONValue node) {
        switch(getJsonStr(node, "easing", "linear")) {
        static foreach(value; [
            "linear",
            "sineIn", "sineOut", "sineInOut",
            "quadIn", "quadOut", "quadInOut",
            "cubicIn", "cubicOut", "cubicInOut",
            "quartIn", "quartOut", "quartInOut",
            "quintIn", "quintOut", "quintInOut",
            "expIn", "expOut", "expInOut",
            "circIn", "circOut", "circInOut",
            "backIn", "backOut", "backInOut",
            "elasticIn", "elasticOut", "elasticInOut",
            "bounceIn", "bounceOut", "bounceInOut"]) {
            mixin("
            case \"" ~ value ~ "\":
                return EasingAlgorithm." ~ value ~ ";
                ");
        }
        default:
            return EasingAlgorithm.linear;
        }
    }

    if(!exists(buildNormalizedPath("assets", "data", "images")))
        return;
	auto files = dirEntries(buildNormalizedPath("assets", "data", "images"), "{*.json}", SpanMode.depth);
    foreach(file; files) {
        JSONValue json = parseJSON(readText(file));

        if(getJsonStr(json, "type") != "spritesheet")
            continue;

        auto srcImage = buildNormalizedPath(dirName(file), convertPathToImport(getJsonStr(json, "texture")));
        auto texture = new Texture(srcImage);
        textureCache.set(texture, srcImage);

        auto elementsNode = getJsonArray(json, "elements");

		foreach(JSONValue elementNode; elementsNode) {
            string name = getJsonStr(elementNode, "name");
            Vec4i clip = getClip(elementNode);
            Flip flip = getFlip(elementNode);

            switch(getJsonStr(elementNode, "type", "null")) {
            case "sprite":
                auto sprite = new Sprite;
                sprite.clip = clip;
                sprite.flip = flip;
                sprite.size = to!Vec2f(clip.zw);
                sprite.texture = texture;
                spriteCache.set(sprite, name);
                break;
            case "tileset":
                auto tileset = new Tileset;
                tileset.clip = clip;
                tileset.size = to!Vec2f(clip.zw);
                tileset.texture = texture;
                tileset.flip = flip;

                tileset.columns = getJsonInt(elementNode, "columns", 1);
                tileset.lines = getJsonInt(elementNode, "lines", 1);
                tileset.maxtiles = getJsonInt(elementNode, "maxtiles", 0);

                tilesetCache.set(tileset, name);
                break;
            case "animation":
                const int columns = getJsonInt(elementNode, "columns", 1);
                const int lines = getJsonInt(elementNode, "lines", 1);
                const int maxtiles = getJsonInt(elementNode, "maxtiles", 0);

                const Vec2i margin = getMargin(elementNode);

                auto animation = new Animation(texture,
                    clip,
                    columns, lines, maxtiles,
                    margin
                    );

                switch(getJsonStr(elementNode, "mode", "once")) {
                case "once":
                    animation.mode = Animation.Mode.once;
                    break;
                case "reverse":
                    animation.mode = Animation.Mode.reverse;
                    break;
                case "loop":
                    animation.mode = Animation.Mode.loop;
                    break;
                case "loop_reverse":
                    animation.mode = Animation.Mode.loopReverse;
                    break;
                case "bounce":
                    animation.mode = Animation.Mode.bounce;
                    break;
                case "bounce_reverse":
                    animation.mode = Animation.Mode.bounceReverse;
                    break;
                default:
                    break;
                }
                animation.duration = getJsonFloat(elementNode, "duration", 1f);
                animation.flip = flip;
                
                animationCache.set(animation, name);
                break;
            case "ninepatch":
                auto ninePath = new NinePatch;
                ninePath.clip = clip;
                ninePath.size = to!Vec2f(clip.zw);
                ninePath.texture = texture;

                ninePath.top = getJsonInt(elementNode, "top", 0);
                ninePath.bottom = getJsonInt(elementNode, "bottom", 0);
                ninePath.left = getJsonInt(elementNode, "left", 0);
                ninePath.right = getJsonInt(elementNode, "right", 0);

                ninePathCache.set(ninePath, name);
                break;
            default:
                break;
            }
        }
    }
}

void loadFonts() {
    auto fontCache = new ResourceCache!TrueTypeFont;
	setResourceCache!TrueTypeFont(fontCache);

    if(!exists(buildNormalizedPath("assets", "media", "font")))
        return;
    auto files = dirEntries(buildNormalizedPath("assets", "media", "font"), "{*.ttf}", SpanMode.depth);
    foreach(file; files) {
        fontCache.set(new TrueTypeFont(file, 20u), baseName(file, ".ttf"));
    }
}

void loadSound() {
    auto soundCache = new ResourceCache!Sound;
	setResourceCache!Sound(soundCache);

    if(!exists(buildNormalizedPath("assets", "media", "sound")))
        return;
    auto files = dirEntries(buildNormalizedPath("assets", "media", "sound"), "{*.wav}", SpanMode.depth);
    foreach(file; files) {
        soundCache.set(new Sound(file), baseName(file, ".wav"));
    }
}

void loadBgm() {
    auto musicCache = new ResourceCache!Music;
	setResourceCache!Music(musicCache);

    if(!exists(buildNormalizedPath("assets", "media", "bgm")))
        return;
    auto files = dirEntries(buildNormalizedPath("assets", "media", "bgm"), "{*.ogg}", SpanMode.depth);
    foreach(file; files) {
        musicCache.set(new Music(file), baseName(file, ".ogg"));
    }
}