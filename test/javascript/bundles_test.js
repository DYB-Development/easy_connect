import { test } from "node:test"
import assert from "node:assert/strict"
import { readFileSync } from "node:fs"

const REACTS_OWN = "Minified React error"

const built = (name) => readFileSync(new URL(`../../app/assets/builds/easy_connect/${name}`, import.meta.url), "utf8")

test("the board page carries no React of its own", () => {
  assert.equal(built("board.js").includes(REACTS_OWN), false)
})
