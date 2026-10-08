import { test } from "node:test"
import assert from "node:assert/strict"
import React from "react"
import { renderToStaticMarkup } from "react-dom/server"
import Board from "../../app/javascript/easy_connect/board/Board.jsx"

const drawn = (columns, lines = [], saved_at = null) => renderToStaticMarkup(React.createElement(Board, { base: "/boards/1", token: "t", initial: { columns, lines, saved_at } }))

test("heads a column with each group's name", () => {
  assert.match(drawn([ { name: "Tickets", items: [] } ]), /<h2[^>]*>Tickets<\/h2>/)
})

test("draws a node showing each item's label in its group's column", () => {
  const html = drawn([ { name: "Tickets", items: [ { id: "DYB-1", label: "Billing report" } ] } ])

  assert.match(html, /<section[^>]*><h2>Tickets<\/h2><div[^>]*data-item="DYB-1"[^>]*>Billing report<\/div><\/section>/)
})

test("says a board that has not been saved is not saved yet", () => {
  assert.match(drawn([]), /<span[^>]*data-saved[^>]*>Not saved yet<\/span>/)
})
