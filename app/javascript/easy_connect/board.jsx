import { createRoot } from "react-dom/client"
import { register } from "keystone_ui-react/src/registry.js"
import { startMounting } from "keystone_ui-react/src/mounting.js"
import Board from "./board/Board"

register("easy_connect/board", Board)

startMounting(document, createRoot)
