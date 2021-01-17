# OPA - Open Policy Agent

## Exercise 1: run rego in VSCode

Open VSCode in \01_first (important!)

Open the rego file: `first.rego`

```rego
package httpapi.authz

default allow = false

allow {
  input.method = "GET"
  input.path = ["salary", input.user]
  input.user = user
}
```

Install the VSCode plugin: Open Policy Agent (tsandall.opa)

This will ask you to install OPA to your home location: `c:\Users\<user>\`

In VSCode, press shift-ctrl-p: OPA: Check File Syntax (happens on save usually)

Open the input data file (side-by-side)

Data file: `input.json`

```json
{
  "user": "alice",
  "method": "GET",
  "path": ["salary", "alice"]
}
```

Select/Focus rego file again and shift-ctrl-p: OPA: Evaluate Package

```json
// Found 1 result in 0µs using /c%3A/Work/Doc/Security/Authorization/OPA/Source/v0.10.7/01_first/input.json as input.
[
  [
    {
      "allow": true // or false, if user not in salary path -> try bob instead of alice
    }
  ]
]
```

## Exercise 2: Run rego in OPA server

Run opa server:\
`c:\Users\<user>\opa.exe run --server`

Check OPA Server: <http://localhost:8181/> or `curl -i localhost:8181`

hello.rego:

```rego
package myHello

greeting = msg {
    info := opa.runtime()
    # hostname := info.env["HOSTNAME"] # Kubernetes sets the HOSTNAME environment variable.
    hostname := "my small world without kubernetes"
    msg := sprintf("hello from %q!", [hostname])
}
```

Store rego in OPA server:\
`curl -X PUT --data-binary @simple.rego localhost:8181/v1/policies/hello`

Check if rego is stored:\
<http://localhost:8181/v1/policies/hello> or \
<http://localhost:8181/v1/policies>

Check result: <http://localhost:8181/v1/data>

To see this:

```json
{"result":{"myHello":{"greeting":"hello from \"my small world without kubernetes\"!"}}}
```

## Exercise 3: Run rego in OPA Server

example from <https://www.openpolicyagent.org/docs/latest/http-api-authorization/>

Run OPA Server

```cmd
c:\Users\bop>opa run --server
```

simple.rego:

```rego
package httpapi.authz

# HTTP API request
import input

default allow = false

# Allow users to get their own salaries.
allow {
  some username
  input.method == "GET"
  input.path = ["finance", "salary", username]
  input.user == username
}
```

Store rego in Server:\
`curl -X PUT --data-binary @simple.rego localhost:8181/v1/policies/simple`

Check if rego is stored:\
<http://localhost:8181/v1/policies/simple> or \
<http://localhost:8181/v1/policies>

Query the policy: (input.json)

```bash
curl -X POST -H "Content-Type: application/json" \
    -d '{"input": {"user": "alice", "path": ["finance", "salary", "alice"], "method": "GET" }}' \
    http://localhost:8181/v1/data/httpapi/authz
```

Check Result:

```json
{"result":{"allow":true}}
```

## Exercise 4: Run example 3 in VSCode

todo: this example does not run in VSCode + VSCode plugin: Open Policy Agent (tsandall.opa): why?

## Next steps

- More useful/practical example
- unit testing of rego
- How to fill OPA Server on startup
- Check ASP.NET Core middleware:

## Information

- Current version of OPA Server: `opa.exe version`: 0.25.2
- Manually download opa from <https://github.com/open-policy-agent/opa/releases>
- OPA REST API: <https://www.openpolicyagent.org/docs/latest/rest-api/>
  - List Policies: <https://www.openpolicyagent.org/docs/latest/rest-api/#list-policies>
  - Get a Policy: <https://www.openpolicyagent.org/docs/latest/rest-api/#get-a-policy>
