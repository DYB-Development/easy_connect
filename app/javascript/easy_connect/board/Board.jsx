import React from "react"

const Board = ({ columns }) => (
  <div>
    {columns.map((column) => (
      <section key={column.name}>
        <h2>{column.name}</h2>
      </section>
    ))}
  </div>
)

export default Board
