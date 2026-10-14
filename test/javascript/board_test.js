import { test } from "node:test"
import assert from "node:assert/strict"
import React from "react"
import { renderToStaticMarkup } from "react-dom/server"
import Board, { Asking, Line, Refusal, Remover } from "../../app/javascript/easy_connect/board/Board.jsx"

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

test("offers to undo the mark on a done item and shows it as done", () => {
  const html = drawn([ { name: "Tickets", items: [ { id: "DYB-1", label: "Billing report", done: true } ] } ])

  assert.match(html, /data-item="DYB-1"[^>]*data-done="true"[^>]*>.*<button[^>]*>Undo done<\/button>/)
})

test("draws each item in a box with the palette's surface and border and the look's corners", () => {
  const html = drawn([ { name: "Tickets", items: [ { id: "DYB-1", label: "Billing report" } ] } ])

  assert.match(html, /<div[^>]*class="ks-panel ks-panel-radius-md ks-panel-padding-sm"[^>]*data-item="DYB-1"[^>]*style="cursor:grab"/)
})

test("shows Save as a primary button", () => {
  assert.match(drawn([]), /<button type="button" class="ks-button ks-button-primary ks-button-md"[^>]*>Save<\/button>/)
})

const asked = (leftOut) => renderToStaticMarkup(React.createElement(Asking, { leftOut, onKeepDrawing: () => {}, onSaveAnyway: () => {} }))

test("shows Save anyway as a primary button", () => {
  assert.match(asked([ "Test" ]), /<button type="button" class="ks-button ks-button-primary ks-button-md"[^>]*>Save anyway<\/button>/)
})

test("shows Mark done and Hide done items as secondary buttons", () => {
  const html = drawn([ { name: "Tickets", items: [ { id: "DYB-1", label: "Billing report" } ] } ])

  assert.deepEqual(html.match(/class="ks-button ks-button-secondary ks-button-sm"[^>]*>[^<]+</g).map((each) => each.split(">")[1].slice(0, -1)), [ "Hide done items", "Mark done" ])
})

test("shows Keep drawing as a secondary button", () => {
  assert.match(asked([ "Test" ]), /<button type="button" class="ks-button ks-button-secondary ks-button-sm"[^>]*>Keep drawing<\/button>/)
})

test("shows an item's detail lines in the muted text colour", () => {
  const html = drawn([ { name: "Pull requests", items: [ { id: "PR-7", label: "Add the report page", details: [ "dyb_web" ] } ] } ])

  assert.match(html, /<div class="ks-tone-muted"[^>]*>dyb_web<\/div>/)
})

test("shows the Open link in the link colour", () => {
  const html = drawn([ { name: "Pull requests", items: [ { id: "PR-7", label: "Add the report page", url: "https://github.com/acme/app/pull/7" } ] } ])

  assert.match(html, /<a [^>]*class="ks-card-link"[^>]*>Open<\/a>/)
})

test("shows the Save anyway prompt as a warning alert", () => {
  assert.match(asked([ "Test" ]), /^<div role="alertdialog" class="ks-alert ks-alert-warning"/)
})

test("shows an error as a danger alert", () => {
  const html = renderToStaticMarkup(React.createElement(Refusal, { error: "Both items are in the same group." }))

  assert.match(html, /^<p role="alert" class="ks-alert ks-alert-error"/)
})

test("shows the button that removes a line in the surface and border colours", () => {
  const html = renderToStaticMarkup(React.createElement(Remover, { line: { midX: 10, midY: 20 }, title: "Remove the line", onRemove: () => {} }))

  assert.match(html, /^<button type="button" class="ks-panel ks-tone-muted"/)
})

test("draws the connecting lines in the app's border colour", () => {
  const html = renderToStaticMarkup(React.createElement("svg", null, React.createElement(Line, { line: { from: "a", to: "b", path: "M 0 0 L 1 1" } })))

  assert.match(html, /<path [^>]*stroke="var\(--ks-color-border\)"/)
})
