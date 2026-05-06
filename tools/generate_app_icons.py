from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
LOGO_PATH = ROOT / "assets" / "branding" / "logo.png"


def _render_icon(src: Image.Image, size: tuple[int, int]) -> Image.Image:
    width, height = size
    canvas = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    scale = min(width / src.width, height / src.height)
    new_size = (max(1, int(src.width * scale)), max(1, int(src.height * scale)))
    resized = src.resize(new_size, Image.LANCZOS)
    offset = ((width - resized.width) // 2, (height - resized.height) // 2)
    canvas.paste(resized, offset, resized)
    return canvas


def _replace_png_icons(src: Image.Image, paths: list[Path]) -> int:
    count = 0
    for path in paths:
        if not path.exists() or path.suffix.lower() != ".png":
            continue
        try:
            with Image.open(path) as target:
                size = target.size
            icon = _render_icon(src, size)
            icon.save(path)
            count += 1
        except Exception:
            continue
    return count


def main() -> None:
    if not LOGO_PATH.exists():
        raise SystemExit(f"Khong tim thay logo: {LOGO_PATH}")

    with Image.open(LOGO_PATH) as logo:
        logo_rgba = logo.convert("RGBA")

        targets: list[Path] = []
        targets += list(ROOT.glob("android/app/src/main/res/mipmap-*/ic_launcher*.png"))
        targets += list(ROOT.glob("ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png"))
        targets += list(ROOT.glob("ios/Runner/Assets.xcassets/LaunchImage.imageset/*.png"))
        targets += list(ROOT.glob("macos/Runner/Assets.xcassets/AppIcon.appiconset/*.png"))
        targets += list(ROOT.glob("web/icons/*.png"))
        targets += [ROOT / "web" / "favicon.png"]

        replaced = _replace_png_icons(logo_rgba, targets)

        ico_path = ROOT / "windows" / "runner" / "resources" / "app_icon.ico"
        if ico_path.exists():
            base = _render_icon(logo_rgba, (256, 256))
            sizes = [(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]
            base.save(ico_path, sizes=sizes)

    print(f"Da cap nhat {replaced} file PNG + app_icon.ico")


if __name__ == "__main__":
    main()
