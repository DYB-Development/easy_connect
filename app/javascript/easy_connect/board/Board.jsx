import React, { useState } from "react"

const columnsSide = { display: "flex", gap: 48, alignItems: "flex-start", padding: 24 }

const column = { display: "flex", flexDirection: "column", gap: 12, minWidth: 240 }

const node = { border: "1px solid #d1d5db", borderRadius: 8, padding: "8px 14px", background: "white" }

const Board = ({ initial }) => {
  const [ drawing ] = useState(initial)

  return (
    <div style={columnsSide}>
      {drawing.columns.map((group) => (
        <section key={group.name} style={column}>
          <h2>{group.name}</h2>
          {group.items.map((item) => (
            <div key={item.id} data-item={item.id} style={node}>{item.label}</div>
          ))}
        </section>
      ))}
    </div>
  )
}

export default Board
