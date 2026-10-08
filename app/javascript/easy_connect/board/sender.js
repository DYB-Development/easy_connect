const UNREACHABLE = "Your change was not saved because the server could not be reached."

export const createSender = ({ base, token, fetch, onError }) => async (path, method, body) => {
  const response = await fetch(base + path, {
    method, headers: { "Content-Type": "application/json", "X-CSRF-Token": token }, body: body && JSON.stringify(body)
  }).catch(() => null)
  if (!response) return onError(UNREACHABLE)
}
