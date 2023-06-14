Nomad Skeleton Driver Plugin
==========

Skeleton project for
[Nomad task driver plugins](https://www.nomadproject.io/docs/drivers/index.html).

This project is intended for bootstrapping development of a new task driver
plugin.

- Website: [https://www.nomadproject.io](https://www.nomadproject.io)
- Mailing list: [Google Groups](http://groups.google.com/group/nomad-tool)

Requirements
-------------------

- [Go](https://golang.org/doc/install) v1.18 or later (to compile the plugin)
- [Nomad](https://www.nomadproject.io/downloads.html) v0.9+ (to run the plugin)

Building the Skeleton Plugin
-------------------

[Generate](https://github.com/hashicorp/nomad-skeleton-driver-plugin/generate)
a new repository in your account from this template by clicking the `Use this
template` button above.

Clone the repository somewhere in your computer. This project uses
[Go modules](https://blog.golang.org/using-go-modules) so you will need to set
the environment variable `GO111MODULE=on` or work outside your `GOPATH` if it
is set to `auto` or not declared.

```sh
$ git clone git@github.com:<ORG>/<REPO>git
```

Enter the plugin directory and update the paths in `go.mod` and `main.go` to
match your repository path.

```diff
// go.mod

- module github.com/hashicorp/nomad-skeleton-driver-plugin
+ module github.com/<ORG>/<REPO>
...
```

```diff
// main.go

package main

import (
    log "github.com/hashicorp/go-hclog"
-   "github.com/hashicorp/nomad-skeleton-driver-plugin/hello"
+.  "github.com/<REPO>/<ORG>/hello"
...

```

Build the skeleton plugin.

```sh
$ make build
```

## Deploying Driver Plugins in Nomad

The initial version of the skeleton is a simple task that outputs a greeting.
You can try it out by starting a Nomad agent and running the job provided in
the `example` folder:

```sh
$ make build
$ nomad agent -dev -config=./example/agent.hcl -plugin-dir=$(pwd)

# in another shell
$ nomad run ./example/example.nomad
$ nomad logs <ALLOCATION ID>
```

Code Organization
-------------------
Follow the comments marked with a `TODO` tag to implement your driver's logic.
For more information check the
[Nomad documentation on plugins](https://www.nomadproject.io/docs/internals/plugins/index.html).

What this plugin doesn't do
---------------------------

We are not going to handle every possible way you have of running a container.

We are not going to handle running containers other than to execute a series of steps with some output at the end

We are not going to support skipping the final commit of a container, even if it's garbage

We are not going to support all the ways a build can be tagged and pushed to a server. Only authentication-free pushes to an OCI registry MAY be supported. Use lifecycle tasks to achieve various uploads.

We are not going to push artifacts, other than to allow them to exist in the allocation directory. Use lifecycle tasks to achieve various uploads.

We are not going to support downloading your repository. Use a lifecycle task.
