workflow "Main" {
  on = "push"
  resolves = "Docker Push"
}

action "Shell Lint" {
  uses = "actions/bin/shellcheck@master"
  args = "entrypoint.sh"
}

action "Bats Test" {
  uses = "actions/bin/bats@master"
  args = "test/*.bats"
}

action "Docker Lint" {
  uses = "docker://replicated/dockerfilelint"
  args = ["Dockerfile"]
}

action "Filter Master" {
  needs = ["Shell Lint", "Bats Test", "Docker Lint"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Docker Build" {
  needs = "Filter Master"
  uses = "actions/docker/cli@master"
  args = "build -t actions-yarn ."
}

action "Docker Tag" {
  needs = "Docker Build"
  uses = "actions/docker/tag@master"
  args = "actions-yarn nuxt/actions-yarn --no-latest"
}

action "Docker Login" {
  needs = "Docker Build"
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Push" {
  needs = ["Docker Tag", "Docker Login"]
  uses = "actions/docker/cli@master"
  args = "push nuxt/actions-yarn"
}