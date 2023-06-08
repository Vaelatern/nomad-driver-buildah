# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

job "example" {
  datacenters = ["dc1"]
  type        = "batch"

  group "example" {

    task "download-workdir-with-authentication-available" {
     # You don't NEED this, but it can help to have advanced preprocessing available, or authenticated downloads
     # of your source code beyond what nomad natively supports. It's a pattern that makes sense before it was
     # redacted here for public consumption.
      driver = "docker"
      config {
        image = "alpine/curl:latest"
        work_dir = "${NOMAD_ALLOC_DIR}/this-is-the-build-task"
        entrypoint = ["${NOMAD_TASK_DIR}/run.sh"]
      }

      template {
        destination = "local/run.sh"
        perms = 755
        data = <<-EOF
          #!/bin/sh
          cd "${NOMAD_TASK_DIR}"
          curl -o out.tgz https://example.com/example.tgz
          mkdir "${NOMAD_ALLOC_DIR}/this-is-the-build-task" &&
            tar -xzvf out.tgz -C "${NOMAD_ALLOC_DIR}/this-is-the-build-task" &&
	    mv "${NOMAD_ALLOC_DIR}/this-is-the-build-task/build/default-env.prod" "${NOMAD_ALLOC_DIR}/this-is-the-build-task/build/default-env" &&
            echo "Extraction complete, enter when ready"
          EOF
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }
    }

    task "this-is-the-build-task" {
      driver = "buildah-ci"
    }

    task "report-status-to-slack" {
      driver = "docker"
      config {
        image = "alpine/curl:latest"
        work_dir = "${NOMAD_ALLOC_DIR}/this-is-the-build-task"
        entrypoint = ["${NOMAD_TASK_DIR}/run.sh"]
      }

      lifecycle {
        hook = "poststop"
      }

      template {
        destination = "./run.sh"
        data =<<-EOF
          #!/bin/sh
          ${file("./slack-notice.sh")}
          EOF
        perms = "755"
      }
    }
  }
}
