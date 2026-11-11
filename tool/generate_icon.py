"""Draws the Donzela app icon from the mockup (screen 16).

Outputs (1024 px, drawn at 4x and downsampled for smooth edges):
  assets/icon/icon.png         full square icon, opaque (iOS and legacy Android)
  assets/icon/foreground.png   adaptive foreground, transparent, mark inside the safe zone
  assets/icon/background.png   adaptive background, brown with the zigzag pattern

Run from the project root:  python3 tool/generate_icon.py
"""
import math
from PIL import Image, ImageDraw

SIZE = 1024
SCALE = 4
BIG = SIZE * SCALE

BROWN = (61, 39, 34, 255)        # #3D2722
TERRACOTTA = (181, 82, 59, 255)  # #B5523B
GOLD = (217, 164, 65, 255)       # #D9A441
ZIGZAG = (92, 60, 52, 255)       # slightly lighter brown for the pattern


def ring_blocks(draw, cx, cy, r_in, r_out, blocks=16, span_deg=15.0):
    """Terracotta blocks around a circle, like the mockup's sun ring."""
    for i in range(blocks):
        centre = i * 360.0 / blocks - 90.0
        a0 = math.radians(centre - span_deg / 2)
        a1 = math.radians(centre + span_deg / 2)
        pts = [
            (cx + r_out * math.cos(a0), cy + r_out * math.sin(a0)),
            (cx + r_out * math.cos(a1), cy + r_out * math.sin(a1)),
            (cx + r_in * math.cos(a1), cy + r_in * math.sin(a1)),
            (cx + r_in * math.cos(a0), cy + r_in * math.sin(a0)),
        ]
        draw.polygon(pts, fill=TERRACOTTA)


def mark(draw, cx, cy, s):
    """The sun-ring mark. s is the outer radius in pixels."""
    ring_blocks(draw, cx, cy, s * 0.70, s, blocks=16, span_deg=14.0)
    draw.ellipse([cx - s * 0.66, cy - s * 0.66, cx + s * 0.66, cy + s * 0.66], fill=BROWN)
    # Crescent: gold disc with an offset brown disc cut out of it.
    r = s * 0.42
    draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=GOLD)
    dr = s * 0.36
    draw.ellipse([cx - dr + s * 0.20, cy - dr - s * 0.05,
                  cx + dr + s * 0.20, cy + dr - s * 0.05], fill=BROWN)


def zigzag_background(draw, size):
    """Rows of zigzag lines, the imigongo-inspired pattern from the mockup."""
    row = size * 0.085
    amp = size * 0.035
    width = max(4, int(size * 0.008))
    y = -row
    while y < size + row:
        pts = []
        x = -size * 0.05
        up = True
        step = size * 0.07
        while x <= size + step:
            pts.append((x, y if up else y + amp * 2))
            up = not up
            x += step
        draw.line(pts, fill=ZIGZAG, width=width, joint="curve")
        y += row


def draw_icon(rounded: bool, with_background: bool, transparent_mark: bool):
    base = (0, 0, 0, 0) if transparent_mark else BROWN
    img = Image.new("RGBA", (BIG, BIG), base)
    d = ImageDraw.Draw(img)
    if with_background:
        d.rectangle([0, 0, BIG, BIG], fill=BROWN)
        zigzag_background(d, BIG)
    c = BIG / 2
    # Full icon: mark fills most of the square. Foreground: smaller, safe zone.
    radius = BIG * (0.42 if transparent_mark else 0.31)  # foreground is inset 16% by Android
    mark(d, c, c, radius)
    img = img.resize((SIZE, SIZE), Image.LANCZOS)
    if rounded:
        mask = Image.new("L", (SIZE, SIZE), 0)
        ImageDraw.Draw(mask).rounded_rectangle([0, 0, SIZE - 1, SIZE - 1], radius=SIZE * 0.22, fill=255)
        img.putalpha(mask)
    return img


def main():
    draw_icon(rounded=False, with_background=True, transparent_mark=False).convert("RGB").save("assets/icon/icon.png")
    draw_icon(rounded=False, with_background=False, transparent_mark=True).save("assets/icon/foreground.png")
    bg = Image.new("RGBA", (BIG, BIG), BROWN)
    zigzag_background(ImageDraw.Draw(bg), BIG)
    bg.resize((SIZE, SIZE), Image.LANCZOS).convert("RGB").save("assets/icon/background.png")
    print("wrote assets/icon/icon.png, foreground.png, background.png")


if __name__ == "__main__":
    main()
