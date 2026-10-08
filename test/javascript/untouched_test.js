import { test } from "node:test"
import assert from "node:assert/strict"
import { untouched } from "../../app/javascript/easy_connect/board/untouched.js"

test("names each item on an ordering board that no line touches", () => {
  const drawing = {
    rows: [ [ { id: "plan", label: "Plan" }, { id: "test", label: "Test" } ], [ { id: "build", label: "Build" } ] ],
    lines: [ { from: "plan", to: "build" } ]
  }

  assert.deepEqual(untouched(drawing), [ "Test" ])
})

test("names nothing on a connections board", () => {
  const drawing = { columns: [ { name: "Tickets", items: [ { id: "DYB-1", label: "Billing report" } ] } ], lines: [] }

  assert.deepEqual(untouched(drawing), [])
})
