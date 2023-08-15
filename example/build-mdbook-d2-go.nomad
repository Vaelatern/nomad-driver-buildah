job "build-mdbook-d2-go" {
  datacenters = ["dc1"]
  type        = "batch"

  group "build-mdbook-d2-go" {

    task "this-is-the-build-task" {
      driver = "buildah-ci"
      config {
	containerfile = "Dockerfile"
      }
      artifact {
        source = "https://github.com/Vaelatern/mdbook-d2-go/archive/refs/heads/master.tar.gz"
        destination = "./"
      }
    }
  }
}
