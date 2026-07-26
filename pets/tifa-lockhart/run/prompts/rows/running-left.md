Create one horizontal animation strip for Codex pet `tifa-lockhart`, state `running-left`.

Use the attached canonical base for identity. Use the attached layout guide only for slot count, spacing, centering, and padding; do not draw the guide.

Output exactly 8 full-body frames in one left-to-right row on flat pure user-selected #00FF00. Treat the row as 8 invisible equal-width slots: one centered complete pose per slot, evenly spaced, with no overlap, clipping, empty slots, labels, or borders.

Identity: same pet in every frame: Tifa Lockhart from Final Fantasy VII Remake: reserved, empathetic, dependable, athletic martial artist with quiet warmth and powerful close-range combat energy. Compact wholesome chibi in her recognizable Remake-inspired outfit: very long dark-brown-to-black hair tied at the tips into a small dolphin-tail split, warm red-brown eyes, sleeveless white athletic top over a black sports layer, high-waisted black pleated skirt with opaque black shorts, black thigh-high stockings, red-and-black combat boots, black fingerless gloves with simple metal knuckle plates, red-and-black guard on her left forearm, and one small white teardrop earring on her left ear. No weapons, no readable runes, no logos, no text; preserve left-side arm guard and earring asymmetry.. Preserve silhouette, face, proportions, markings, palette, material, style, and props.
Style: Pet-safe sprite: compact full-body mascot, readable in a 192x208 cell, clear silhouette, simple face, stable palette/materials, and crisp edges for chroma-key extraction. Style `pixel`: Pixel-art-adjacent digital mascot with a chunky silhouette, simple dark outline, limited palette, flat cel shading, and visible stepped edges. User style notes: Polished anime pixel-art chibi matching the repository pets: large expressive head and eyes, compact athletic full-body proportions, clean clustered pixels, crisp dark outline, limited palette, flat cel shading, readable long hair, gloves, left arm guard, and red boots at pet size..
Animation continuity: keep apparent pet scale and baseline stable within the row unless the state itself intentionally changes vertical position, such as `jumping`. Move the pose within the slot instead of redrawing the pet larger or smaller frame to frame.

State action: Dragging-left loop: show directional movement to the left through body and limb poses only.

State requirements:
- Show directional drag movement to the left through body, limb, and prop movement only.
- The row must unmistakably face and travel left.
- The movement cadence must alternate visibly across the 8 frames instead of repeating one nearly static stride.
- Do not draw speed lines, dust clouds, floor shadows, motion trails, or detached motion effects.

Clean extraction: crisp opaque edges, safe padding, no scenery, text, guide marks, checkerboard, shadows, glows, motion blur, speed lines, dust, detached effects, stray pixels, or chroma-key colors inside the pet.
