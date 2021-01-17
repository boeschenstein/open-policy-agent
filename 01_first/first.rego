package httpapi.authz

default allow = false

allow {
  input.method = "GET"
  input.path = ["salary", input.user]
  input.user = user
}
