export const anchor = (box, side, frame, surface) => {
  const left = box.left - frame.left + surface.scrollLeft
  const top = box.top - frame.top + surface.scrollTop

  if (side === "left") return { x: left, y: top + box.height / 2 }
  return { x: left + box.width, y: top + box.height / 2 }
}

export const between = (fromBox, toBox, frame, surface) => {
  const a = anchor(fromBox, "right", frame, surface)
  const b = anchor(toBox, "left", frame, surface)

  return { path: `M ${a.x} ${a.y} L ${b.x} ${b.y}`, midX: (a.x + b.x) / 2, midY: (a.y + b.y) / 2 }
}
