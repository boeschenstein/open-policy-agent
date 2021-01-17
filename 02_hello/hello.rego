package myHello

greeting = msg {
    info := opa.runtime()
    # hostname := info.env["HOSTNAME"] # Kubernetes sets the HOSTNAME environment variable.
    hostname := "my small world without kubernetes"
    msg := sprintf("hello from %q!", [hostname])
}
