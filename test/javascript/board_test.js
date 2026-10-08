import { test } from "node:test"
import assert from "node:assert/strict"
import React from "react"
import { renderToStaticMarkup } from "react-dom/server"
import Board from "../../app/javascript/easy_connect/board/Board.jsx"

const drawn = (columns) => renderToStaticMarkup(React.createElement(Board, { columns }))

test("heads a column with each group's name", () => {
  assert.match(drawn([ { name: "Tickets", items: [] } ]), /<h2[^>]*>Tickets<\/h2>/)
})
