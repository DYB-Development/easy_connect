export const anchor = (box, side, frame, surface) => {
  const left = box.left - frame.left + surface.scrollLeft
  const top = box.top - frame.top + surface.scrollTop

  if (side === "left") return { x: left, y: top + box.height / 2 }
  if (side === "top") return { x: left + box.width / 2, y: top }
  if (side === "bottom") return { x: left + box.width / 2, y: top + box.height }
  return { x: left + box.width, y: top + box.height / 2 }
}

const joined = (a, b) => ({ path: `M ${a.x} ${a.y} L ${b.x} ${b.y}`, midX: (a.x + b.x) / 2, midY: (a.y + b.y) / 2 })

export const downward = (fromBox, toBox, frame, surface) =>
  joined(anchor(fromBox, "bottom", frame, surface), anchor(toBox, "top", frame, surface))

export const between = (fromBox, toBox, frame, surface) => {
  const a = anchor(fromBox, "right", frame, surface)
  const b = anchor(toBox, "left", frame, surface)

  return joined(a, b)
}
