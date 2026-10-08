const UNREACHABLE = "Your change was not saved because the server could not be reached."

export const createSender = ({ base, token, fetch, onDrawing, onError, onRedirect }) => async (path, method, body) => {
  const response = await fetch(base + path, {
    method, headers: { "Content-Type": "application/json", "X-CSRF-Token": token }, body: body && JSON.stringify(body)
  }).catch(() => null)
  if (!response) return onError(UNREACHABLE)

  if (!response.ok) {
    const answered = await response.json().catch(() => ({}))
    return onError(answered.error || "That change was refused.")
  }

  onError(null)

  const accepted = response.status === 204 ? {} : await response.json().catch(() => ({}))
  if (accepted.redirect) return onRedirect(accepted.redirect)

  onDrawing(await (await fetch(base + ".json", { headers: { Accept: "application/json" } })).json())
}
