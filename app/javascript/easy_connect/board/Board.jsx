import React, { useLayoutEffect, useRef, useState } from "react"
import { createSender } from "./sender"
import { between, downward } from "./lines"

const surfaceSide = { position: "relative" }

const columnsSide = { display: "flex", gap: 160, alignItems: "flex-start", padding: 24 }

const column = { display: "flex", flexDirection: "column", gap: 12, minWidth: 240 }

const rowsSide = { display: "flex", flexDirection: "column", gap: 72, padding: 24 }

const row = { display: "flex", gap: 24, alignItems: "flex-start" }

const node = { border: "1px solid #d1d5db", borderRadius: 8, padding: "8px 14px", background: "white", cursor: "grab" }

const toolbar = { display: "flex", alignItems: "center", gap: 12, padding: "0 24px" }

const saveButton = { padding: "8px 16px", borderRadius: 8, border: 0, background: "#2563eb", color: "white", fontWeight: 600, cursor: "pointer" }

const savedWhen = (savedAt) => savedAt ? `Saved ${new Date(savedAt).toLocaleString()}` : "Not saved yet"

const refusal = { margin: "0 24px", padding: "8px 14px", borderRadius: 8, background: "#fef2f2", color: "#991b1b" }

const remover = { position: "absolute", transform: "translate(-50%, -50%)", width: 22, height: 22, borderRadius: 11, border: "1px solid #d1d5db", background: "white", color: "#4b5563", cursor: "pointer", lineHeight: "18px", padding: 0 }

const linesLayer = { position: "absolute", inset: 0, width: "100%", height: "100%", pointerEvents: "none", overflow: "visible" }

const useLines = (drawing, surface, nodes) => {
  const [ placed, setPlaced ] = useState([])

  useLayoutEffect(() => {
    const measure = () => {
      const frame = surface.current?.getBoundingClientRect()
      if (!frame) return

      setPlaced(drawing.lines.flatMap((line) => {
        const fromBox = nodes.current[line.from]?.getBoundingClientRect()
        const toBox = nodes.current[line.to]?.getBoundingClientRect()
        if (!fromBox || !toBox) return []

        const joining = drawing.rows ? downward : between
        return [ { ...line, ...joining(fromBox, toBox, frame, surface.current) } ]
      }))
    }

    measure()
    window.addEventListener("resize", measure)

    return () => window.removeEventListener("resize", measure)
  }, [ drawing ])

  return placed
}

const Board = ({ base, token, initial }) => {
  const [ drawing, setDrawing ] = useState(initial)
  const [ error, setError ] = useState(null)
  const surface = useRef(null)
  const nodes = useRef({})
  const placed = useLines(drawing, surface, nodes)

  const send = createSender({ base, token, fetch: (...request) => window.fetch(...request), onDrawing: setDrawing, onError: setError, onRedirect: (address) => window.location.assign(address) })

  const items = drawing.rows ? drawing.rows.flat() : drawing.columns.flatMap((group) => group.items)
  const labels = Object.fromEntries(items.map((item) => [ item.id, item.label ]))

  const dropped = (event, to) => {
    event.preventDefault()
    const from = event.dataTransfer.getData("text/plain")
    if (from) send("/lines", "POST", { from, to })
  }

  const drawNode = (item) => (
    <div key={item.id}
         ref={(element) => { nodes.current[item.id] = element }}
         data-item={item.id}
         draggable
         onDragStart={(event) => { event.dataTransfer.effectAllowed = "link"; event.dataTransfer.setData("text/plain", item.id) }}
         onDragOver={(event) => event.preventDefault()}
         onDrop={(event) => dropped(event, item.id)}
         style={node}>{item.label}</div>
  )

  return (
    <div ref={surface} style={surfaceSide}>
      <div style={toolbar}>
        <button type="button" style={saveButton} onClick={() => send("/save", "POST")}>Save</button>
        <span data-saved>{savedWhen(drawing.saved_at)}</span>
      </div>
      {error && <p role="alert" style={refusal}>{error}</p>}
      {drawing.rows ? (
        <div style={rowsSide}>
          {drawing.rows.map((held, index) => (
            <div key={index} data-row={index} style={row}>{held.map(drawNode)}</div>
          ))}
        </div>
      ) : (
        <div style={columnsSide}>
          {drawing.columns.map((group) => (
            <section key={group.name} style={column}>
              <h2>{group.name}</h2>
              {group.items.map(drawNode)}
            </section>
          ))}
        </div>
      )}
      <svg style={linesLayer}>
        {placed.map((line) => (
          <path key={`${line.from} ${line.to}`} data-line={`${line.from} ${line.to}`} d={line.path} stroke="#4b5563" strokeWidth="2" fill="none" />
        ))}
      </svg>
      {placed.map((line) => (
        <button key={`${line.from} ${line.to}`} type="button" style={{ ...remover, left: line.midX, top: line.midY }}
                title={`Remove the line from ${labels[line.from]} to ${labels[line.to]}`}
                onClick={() => send("/lines", "DELETE", { from: line.from, to: line.to })}>×</button>
      ))}
    </div>
  )
}

export default Board
