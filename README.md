# nomad-plugin-buildah-ci

A plugin for building containers using [buildah](https://buildah.io/)
on your Nomad cluster.  You can use this tool to make use of the
machines you already have to build containers locally from
Containerfiles and Dockerfiles.

## Example Build

Creating a task using the `buildah-ci` plugin 

```
    task "this-is-the-build-task" {
      driver = "buildah-ci"
      config {
    	dockerfile = "Dockerfile"
      }
      artifact {
        source = "https://github.com/Vaelatern/mdbook-d2-go/archive/refs/heads/master.tar.gz"
        destination = "./"
      }
    }
```

Note that the resultant container doesn't get pushed anywhere.  To
actually consume the container externally, you'll need to add
additional tasks that are part of a lifecycle that moves the built
container into one or more registries.

## Deploying Driver Plugins in Nomad

The initial version of the skeleton is a simple task that outputs a
greeting.  You can try it out by starting a Nomad agent and running
the job provided in the `example` folder:

```sh
$ make build
$ nomad agent -dev -config=./example/agent.hcl -plugin-dir=$(pwd)

# in another shell
$ nomad run ./example/example.nomad
$ nomad logs <ALLOCATION ID>
```


## What this plugin doesn't do

In order to maintain a clear focus for the plugin, the following items
are defined as out of scope:

  * We are not going to handle every possible way you have of running
    a container.

  * We are not going to handle running containers other than to
    execute a series of steps with some output at the end

  * We are not going to support skipping the final commit of a
    container, even if it's garbage

  * We are not going to support all the ways a build can be tagged and
    pushed to a server. Only authentication-free pushes to an OCI
    registry MAY be supported. Use lifecycle tasks to achieve various
    uploads.

  * We are not going to push artifacts, other than to allow them to
    exist in the allocation directory. Use lifecycle tasks to achieve
    various uploads.

  * We are not going to support downloading your repository. Use a
    lifecycle task.
