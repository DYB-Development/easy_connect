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

const answering = (status, body) => async () => ({ ok: status < 400, status, json: async () => body })

test("a refused edit shows the reason the server gave", async () => {
  const errors = []

  await sending(answering(422, { error: "Both items are in the same group." }), errors)("/lines", "POST", {})

  assert.deepEqual(errors, [ "Both items are in the same group." ])
})
