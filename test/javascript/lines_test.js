import { test } from "node:test"
import assert from "node:assert/strict"
import { between } from "../../app/javascript/easy_connect/board/lines.js"

const frame = { left: 10, top: 20 }
const surface = { scrollLeft: 0, scrollTop: 0 }

test("a line runs from the right edge of the first item to the left edge of the second", () => {
  const from = { left: 10, top: 20, width: 100, height: 40 }
  const to = { left: 310, top: 120, width: 100, height: 40 }

  assert.equal(between(from, to, frame, surface).path, "M 100 20 L 300 120")
})
