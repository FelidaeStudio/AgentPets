import argparse
import json
from pathlib import Path

from PIL import Image


def alpha_bbox(image: Image.Image):
    return image.getchannel("A").getbbox()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", required=True)
    parser.add_argument("--reference", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--json-out", required=True)
    args = parser.parse_args()

    source = Image.open(args.source).convert("RGBA")
    reference = Image.open(args.reference).convert("RGBA")
    pixels = []
    for red, green, blue, _ in source.getdata():
        distance = ((red - 0) ** 2 + (green - 255) ** 2 + (blue - 0) ** 2) ** 0.5
        alpha = 0 if distance < 92 else 255
        pixels.append((red, green, blue, alpha))
    source.putdata(pixels)

    source_bbox = alpha_bbox(source)
    reference_bbox = alpha_bbox(reference)
    if not source_bbox or not reference_bbox:
        raise SystemExit("source or reference has no visible sprite")

    cropped = source.crop(source_bbox)
    target_width = reference_bbox[2] - reference_bbox[0]
    target_height = reference_bbox[3] - reference_bbox[1]
    scale = min(target_width / cropped.width, target_height / cropped.height)
    resized_size = (max(1, round(cropped.width * scale)), max(1, round(cropped.height * scale)))
    cropped = cropped.resize(resized_size, Image.Resampling.LANCZOS)

    canvas = Image.new("RGBA", reference.size, (0, 0, 0, 0))
    reference_center_x = (reference_bbox[0] + reference_bbox[2]) // 2
    left = reference_center_x - cropped.width // 2
    top = reference_bbox[3] - cropped.height
    canvas.alpha_composite(cropped, (left, top))

    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(output)
    metadata = {
        "source": str(Path(args.source)),
        "reference": str(Path(args.reference)),
        "output": str(output),
        "source_bbox": list(source_bbox),
        "reference_bbox": list(reference_bbox),
        "scale": scale,
        "placement": [left, top],
        "output_size": list(canvas.size),
    }
    Path(args.json_out).write_text(json.dumps(metadata, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
