import React, { useLayoutEffect, useRef, useState } from "react"
import Button from "keystone_ui-react/src/Button.jsx"
import { createSender } from "./sender"
import { between, downward } from "./lines"
import { untouched } from "./untouched"

const surfaceSide = { position: "relative" }

const columnsSide = { display: "flex", gap: 160, alignItems: "flex-start", padding: 24 }

const column = { display: "flex", flexDirection: "column", gap: 12, minWidth: 240 }

const rowsSide = { display: "flex", flexDirection: "column", gap: 72, padding: 24 }

const row = { display: "flex", gap: 24, alignItems: "flex-start" }

const node = { cursor: "grab" }

const nodeLook = "ks-panel ks-panel-radius-md ks-panel-padding-sm"

const toolbar = { display: "flex", alignItems: "center", gap: 12, padding: "0 24px" }

const savedWhen = (savedAt) => savedAt ? `Saved ${new Date(savedAt).toLocaleString()}` : "Not saved yet"

const named = { fontWeight: 600 }

const detail = { fontSize: 13 }

const onTheWeb = (address) => /^https?:\/\//.test(address || "")

const marker = { marginTop: 6 }

const asking = { margin: "0 24px" }

const refusal = { margin: "0 24px" }

export const Asking = ({ leftOut, onKeepDrawing, onSaveAnyway }) => (
  <div role="alertdialog" className="ks-alert ks-alert-warning" style={asking}>
    <p>No line touches {leftOut.join(", ")}. Save anyway?</p>
    <div style={toolbar}>
      <Button type="button" variant="secondary" size="sm" onClick={onKeepDrawing}>Keep drawing</Button>
      <Button type="button" onClick={onSaveAnyway}>Save anyway</Button>
    </div>
  </div>
)

export const Refusal = ({ error }) => <p role="alert" className="ks-alert ks-alert-error" style={refusal}>{error}</p>

const remover = { position: "absolute", transform: "translate(-50%, -50%)", width: 22, height: 22, borderRadius: 11, border: "1px solid #d1d5db", background: "white", color: "#4b5563", cursor: "pointer", lineHeight: "18px", padding: 0 }

const linesLayer = { position: "absolute", inset: 0, width: "100%", height: "100%", pointerEvents: "none", overflow: "visible" }

const useLines = (drawing, surface, nodes, hidingDone) => {
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
  }, [ drawing, hidingDone ])

  return placed
}

const Board = ({ base, token, initial }) => {
  const [ drawing, setDrawing ] = useState(initial)
  const [ error, setError ] = useState(null)
  const surface = useRef(null)
  const nodes = useRef({})
  const [ hidingDone, setHidingDone ] = useState(false)
  const [ leftOut, setLeftOut ] = useState([])
  const placed = useLines(drawing, surface, nodes, hidingDone)
  const shown = (held) => held.filter((item) => !(hidingDone && item.done))

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
         className={nodeLook}
         ref={(element) => { nodes.current[item.id] = element }}
         data-item={item.id}
         data-done={item.done ? "true" : undefined}
         draggable
         onDragStart={(event) => { event.dataTransfer.effectAllowed = "link"; event.dataTransfer.setData("text/plain", item.id) }}
         onDragOver={(event) => event.preventDefault()}
         onDrop={(event) => dropped(event, item.id)}
         style={item.done ? { ...node, opacity: 0.55 } : node}>
      <div style={named}>{item.label}</div>
      {(item.details || []).map((line) => <div key={line} className="ks-tone-muted" style={detail}>{line}</div>)}
      <Button type="button" variant="secondary" size="sm" draggable={false} style={marker}
              onClick={() => send(`/items/${encodeURIComponent(item.id)}`, "PATCH", { done: !item.done })}>{item.done ? "Undo done" : "Mark done"}</Button>
      {onTheWeb(item.url) && <a href={item.url} target="_blank" rel="noopener noreferrer" draggable={false} className="ks-card-link">Open</a>}
    </div>
  )

  return (
    <div ref={surface} style={surfaceSide}>
      <div style={toolbar}>
        <Button type="button" onClick={() => {
          const missing = untouched(drawing)
          missing.length ? setLeftOut(missing) : send("/save", "POST")
        }}>Save</Button>
        <Button type="button" variant="secondary" size="sm" onClick={() => setHidingDone(!hidingDone)}>{hidingDone ? "Show done items" : "Hide done items"}</Button>
        <span data-saved>{savedWhen(drawing.saved_at)}</span>
      </div>
      {leftOut.length > 0 && (
        <Asking leftOut={leftOut}
                onKeepDrawing={() => setLeftOut([])}
                onSaveAnyway={() => { setLeftOut([]); send("/save", "POST") }} />
      )}
      {error && <Refusal error={error} />}
      {drawing.rows ? (
        <div style={rowsSide}>
          {drawing.rows.map((held, index) => (
            <div key={index} data-row={index} style={row}>{shown(held).map(drawNode)}</div>
          ))}
        </div>
      ) : (
        <div style={columnsSide}>
          {drawing.columns.map((group) => (
            <section key={group.name} style={column}>
              <h2>{group.name}</h2>
              {shown(group.items).map(drawNode)}
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
