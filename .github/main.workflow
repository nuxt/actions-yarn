workflow "Main" {
  on = "push"
  resolves = "Docker Build"
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
  uses = "docker://replicated/dockerfilelint@sha256:861072158830bd6af2ab9236a2ac4b51533996b02cb176b2a5a34e7ce62f9bff"
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

# action "Docker Tag" {
#   needs = "Docker Build"
#   uses = "actions/docker/tag@master"
#   args = "actions-yarn nuxt/actions-yarn --no-latest"
# }

# action "Docker Login" {
#   needs = "Docker Build"
#   uses = "actions/docker/login@master"
#   secrets = [
#     "DOCKER_PASSWORD",
#     "DOCKER_USERNAME",
#   ]
# }

# action "Docker Push" {
#   needs = ["Docker Tag", "Docker Login"]
#   uses = "actions/docker/cli@master"
#   args = "push nuxt/actions-yarn"
# }
