export const untouched = (drawing) => {
  if (!drawing.rows) return []

  const touched = new Set(drawing.lines.flatMap((line) => [ line.from, line.to ]))

  return drawing.rows.flat().filter((item) => !touched.has(item.id)).map((item) => item.label)
}
