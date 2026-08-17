#!/usr/bin/env python3
"""UnitPro icon — purple swap arrows on black."""

from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets" / "logo.png"
OUT_FG = ROOT / "assets" / "icon_foreground.png"

S = 1024
PURPLE = (139, 124, 255)
LILAC = (184, 174, 255)
WHITE = (244, 242, 250)


def bg(size: int) -> Image.Image:
    img = Image.new("RGB", (size, size), (0, 0, 0))
    px = img.load()
    cx = cy = size / 2
    for y in range(size):
        for x in range(size):
            dx = (x - cx) / size
            dy = (y - cy) / size
            d = math.sqrt(dx * dx + dy * dy)
            lift = max(0.0, 1.0 - d * 1.7)
            px[x, y] = (
                min(255, int(12 + 48 * lift)),
                min(255, int(10 + 36 * lift)),
                min(255, int(28 + 90 * lift)),
            )
    return img.convert("RGBA")


def arrows(canvas: Image.Image) -> None:
    layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    cx, cy = S // 2, S // 2
    w, h, gap = 70, 220, 48
    # left up arrow
    d.rounded_rectangle([cx - gap - w, cy - h // 2, cx - gap, cy + h // 2 - 40], radius=28, fill=PURPLE + (255,))
    d.polygon([(cx - gap - w - 36, cy - h // 2 + 36), (cx - gap - w // 2, cy - h // 2 - 70), (cx - gap + 36, cy - h // 2 + 36)], fill=LILAC + (255,))
    # right down arrow
    d.rounded_rectangle([cx + gap, cy - h // 2 + 40, cx + gap + w, cy + h // 2], radius=28, fill=WHITE + (230,))
    d.polygon([(cx + gap - 36, cy + h // 2 - 36), (cx + gap + w // 2, cy + h // 2 + 70), (cx + gap + w + 36, cy + h // 2 - 36)], fill=PURPLE + (255,))
    canvas.alpha_composite(layer.filter(ImageFilter.GaussianBlur(2)))
    canvas.alpha_composite(layer)


def compose(*, with_bg: bool) -> Image.Image:
    canvas = bg(S) if with_bg else Image.new("RGBA", (S, S), (0, 0, 0, 0))
    arrows(canvas)
    return canvas


def main() -> None:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    compose(with_bg=True).save(OUT)
    compose(with_bg=False).save(OUT_FG)
    print(OUT)
    print(OUT_FG)


if __name__ == "__main__":
    main()
