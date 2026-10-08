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

  assert.match(html, /<section[^>]*><h2>Tickets<\/h2><div[^>]*data-item="DYB-1"[^>]*><div[^>]*>Billing report<\/div>/)
})

test("says a board that has not been saved is not saved yet", () => {
  assert.match(drawn([]), /<span[^>]*data-saved[^>]*>Not saved yet<\/span>/)
})

test("says when a saved board was saved", () => {
  assert.match(drawn([], [], "2026-10-08T14:05:00Z"), /<span[^>]*data-saved[^>]*>Saved [^<]+<\/span>/)
})

const ordered = (rows) => renderToStaticMarkup(React.createElement(Board, { base: "/boards/1", token: "t", initial: { rows, lines: [], saved_at: null } }))

test("draws an ordering board's items side by side in their rows", () => {
  const html = ordered([ [ { id: "plan", label: "Plan" } ], [ { id: "build", label: "Build" }, { id: "ship", label: "Ship" } ] ])

  assert.match(html, /<div[^>]*data-row="1"[^>]*><div[^>]*data-item="build"[^>]*><div[^>]*>Build<\/div>.*data-item="ship"[^>]*><div[^>]*>Ship<\/div>/)
})

test("shows an item's detail lines under its label", () => {
  const html = drawn([ { name: "Pull requests", items: [ { id: "PR-7", label: "Add the report page", details: [ "dyb_web", "Merged Oct 2" ] } ] } ])

  assert.match(html, /Add the report page<\/div><div[^>]*>dyb_web<\/div><div[^>]*>Merged Oct 2<\/div>/)
})

test("links a node to its item in a new tab", () => {
  const html = drawn([ { name: "Pull requests", items: [ { id: "PR-7", label: "Add the report page", url: "https://github.com/acme/app/pull/7" } ] } ])

  assert.match(html, /<a href="https:\/\/github.com\/acme\/app\/pull\/7" target="_blank" rel="noopener noreferrer"[^>]*>Open<\/a>/)
})

test("draws no link for an address that is not a web address", () => {
  const html = drawn([ { name: "Pull requests", items: [ { id: "PR-7", label: "Add the report page", url: "javascript:alert(1)" } ] } ])

  assert.doesNotMatch(html, /<a /)
})

test("offers to mark an item done from its node", () => {
  const html = drawn([ { name: "Tickets", items: [ { id: "DYB-1", label: "Billing report" } ] } ])

  assert.match(html, /data-item="DYB-1"[^>]*>.*<button[^>]*>Mark done<\/button>/)
})
