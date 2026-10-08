export const untouched = (drawing) => {
  const touched = new Set(drawing.lines.flatMap((line) => [ line.from, line.to ]))

  return drawing.rows.flat().filter((item) => !touched.has(item.id)).map((item) => item.label)
}
