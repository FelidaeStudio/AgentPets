import argparse
from pathlib import Path

from PIL import Image, ImageOps


CELL_WIDTH = 192
CELL_HEIGHT = 208


def cell(row: Image.Image, index: int) -> Image.Image:
    left = index * CELL_WIDTH
    return row.crop((left, 0, left + CELL_WIDTH, CELL_HEIGHT))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--accepted-first-half", required=True)
    parser.add_argument("--registered-row-9", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    first_half = Image.open(args.accepted_first_half).convert("RGBA")
    if first_half.height > CELL_HEIGHT:
        first_half = first_half.crop((0, CELL_HEIGHT * 10, CELL_WIDTH * 8, CELL_HEIGHT * 11))
    row9 = Image.open(args.registered_row_9).convert("RGBA")
    output = Image.new("RGBA", (CELL_WIDTH * 8, CELL_HEIGHT), (0, 0, 0, 0))

    # Preserve the visually accepted 180→270 direction skeleton.
    for index in range(5):
        output.alpha_composite(cell(first_half, index), (index * CELL_WIDTH, 0))

    # Screen-horizontal mirrors of 067.5, 045, and 022.5 provide only the
    # desired 292.5, 315, and 337.5 facial-orientation skeleton. This guide is
    # never packaging-eligible; image generation must redraw a coherent row.
    for target_index, source_index in zip((5, 6, 7), (3, 2, 1)):
        output.alpha_composite(ImageOps.mirror(cell(row9, source_index)), (target_index * CELL_WIDTH, 0))

    destination = Path(args.output)
    destination.parent.mkdir(parents=True, exist_ok=True)
    output.save(destination)


if __name__ == "__main__":
    main()
