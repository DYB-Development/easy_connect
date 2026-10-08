import { test } from "node:test"
import assert from "node:assert/strict"
import { createSender } from "../../app/javascript/easy_connect/board/sender.js"

const sending = (fetch, errors = [], drawings = []) =>
  createSender({ base: "/boards/1", token: "t", fetch, onDrawing: (drawing) => drawings.push(drawing), onError: (error) => errors.push(error) })

test("an edit that cannot reach the server says it was not saved", async () => {
  const errors = []
  const unreachable = async () => { throw new TypeError("Failed to fetch") }

  await sending(unreachable, errors)("/lines", "POST", {})

  assert.deepEqual(errors, [ "Your change was not saved because the server could not be reached." ])
})
